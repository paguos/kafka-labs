GIT_CP_KAFKA = $(shell ls | grep cp-helm-charts)
HELM_LIST = list
K3D_CONFIG = config
K3D_LIST = $(shell k3d list | grep kafka-labs | cut -c 3-12)

REGISTRY = confluentinc
IMAGE_TAG = 5.4.1
IMAGES = cp-kafka-rest cp-enterprise-control-center cp-ksql-server cp-schema-registry cp-kafka-connect

k3d/setup:
ifeq ($(K3D_LIST), kafka-labs)
	$(info Staring k3d cluster ...)
	k3d start --name=kafka-labs
else
	$(info Creating k3d cluster ...)
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
	kubectl apply -f scripts/kubernetes/namespace.yml;

pull/images:
	$(info Downloading docker images ...)
	for i in $(IMAGES); do docker pull $(REGISTRY)/$$i:$(IMAGE_TAG); done

k3d/import:
	$(info Importing docker images to k3d ...)
	for i in $(IMAGES); do k3d i --name=kafka-labs $(REGISTRY)/$$i:$(IMAGE_TAG); done

install/charts: clone/cp-kafka create/namespace
	$(info Installing helm charts ...)
ifeq ($(HELM_LIST), cp)
	export KUBECONFIG=$(K3D_CONFIG); \
	helm upgrade cp cp-helm-charts --namespace=kafka
else
	export KUBECONFIG=$(K3D_CONFIG); \
	helm install cp cp-helm-charts --namespace=kafka
endif


.PHONY: start
start: k3d/setup pull/images k3d/import install/charts

.PHONY: pf
pf:
	# Start port-forwards
	./scripts/port-forward.sh

.PHONY: stop
stop:
	$(info Stoping k3d cluster ...)
	k3d stop --name=kafka-labs

.PHONY: clean
clean:
	$(info Deleting k3d cluster ...)
	k3d delete --name=kafka-labs