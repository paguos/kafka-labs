GIT_CP_KAFKA = $(shell ls | grep cp-helm-charts)
HELM_LIST = list
K3D_CONFIG = config
K3D_LIST = $(shell k3d list | grep kafka-labs | cut -c 3-12)

REGISTRY = confluentinc
IMAGE_TAG = 5.4.1
IMAGES = cp-kafka-rest cp-enterprise-control-center cp-ksql-server cp-schema-registry cp-kafka-connect

k3d/setup:
ifeq ($(K3D_LIST), kafka-labs)
	k3d start --name=kafka-labs
else
	k3d create --name=kafka-labs --wait=30
endif
override HELM_LIST = $(shell KUBECONFIG=$(K3D_CONFIG) helm list --namespace=kafka | grep cp | cut -c 1-2)
override K3D_CONFIG = $(shell k3d get-kubeconfig --name=kafka-labs)

clone/cp-kafka:
ifneq ($(GIT_CP_KAFKA), cp-helm-charts)
	git clone git@github.com:confluentinc/cp-helm-charts.git
endif

create/namespace:
	export KUBECONFIG=$(K3D_CONFIG); \
	kubectl apply -f manifests/namespace.yml;

pull/images:
	for i in $(IMAGES); do docker pull $(REGISTRY)/$$i:$(IMAGE_TAG); done

k3d/import:
	for i in $(IMAGES); do k3d i --name=kafka-labs $(REGISTRY)/$$i:$(IMAGE_TAG); done

install/charts: clone/cp-kafka create/namespace
ifeq ($(HELM_LIST), cp)
	export KUBECONFIG=$(K3D_CONFIG); \
	helm upgrade cp cp-helm-charts --namespace=kafka
else
	export KUBECONFIG=$(K3D_CONFIG); \
	helm install cp cp-helm-charts --namespace=kafka
endif


.PHONY: start
start: k3d/setup pull/images k3d/import install/charts

.PHONY: stop
stop:
	k3d stop --name=kafka-labs

.PHONY: clean
clean:
	export KUBECONFIG=$(K3D_CONFIG); \
	helm delete cp  --namespace=kafka