GIT_CP_KAFKA = $(shell ls | grep cp-helm-charts)
K3D_CONFIG = config
K3D_LIST = $(shell k3d list | grep kafka-labs | cut -c 3-12)
K3D_IMPORT=true
OS=darwin

HELM_CP=none
HELM_MSSQL=none

CP_REGISTRY = confluentinc
CP_IMAGE_TAG = 5.4.1
CP_IMAGES = cp-enterprise-kafka cp-zookeeper

k3d/setup:
ifeq ($(K3D_LIST), kafka-labs)
	$(info Staring k3d cluster ...)
	k3d start --name=kafka-labs
else
	$(info Creating k3d cluster ...)
	k3d create --name=kafka-labs --wait=30
endif
override K3D_CONFIG = $(shell k3d get-kubeconfig --name=kafka-labs)

create/namespace:
	export KUBECONFIG=$(K3D_CONFIG); \
	kubectl apply -f kubernetes/namespace.yml;

cp/pull-images:
ifeq ($(K3D_IMPORT), true)
	$(info Downloading docker images ...)
	for i in $(CP_IMAGES); do docker pull $(CP_REGISTRY)/$$i:$(CP_IMAGE_TAG); done
	$(info Importing docker images to k3d ...)
	for i in $(CP_IMAGES); do k3d i --name=kafka-labs $(CP_REGISTRY)/$$i:$(CP_IMAGE_TAG); done
endif

kafka-connect/build:
ifeq ($(K3D_IMPORT), true)
	docker build . -t custom-kafka-connect:test
	k3d i --name=kafka-labs custom-kafka-connect:test
endif

cp/charts: kafka-connect/build cp/pull-images
override HELM_CP = $(shell KUBECONFIG=$(K3D_CONFIG) helm list --namespace=kafka | grep cp | cut -c 1-2)
ifeq ($(HELM_CP), cp)
	export KUBECONFIG=$(K3D_CONFIG); \
	helm upgrade cp kubernetes/cp-kafka --namespace=kafka --values kubernetes/values/cp.yml
else
	export KUBECONFIG=$(K3D_CONFIG); \
	helm install cp kubernetes/cp-kafka --namespace=kafka --values kubernetes/values/cp.yml
endif

mssql/pull-images:
ifeq ($(K3D_IMPORT), true)
	docker pull microsoft/mssql-server-linux:2017-CU5
	k3d i --name=kafka-labs microsoft/mssql-server-linux:2017-CU5
endif

mssql/charts: mssql/pull-images
override HELM_MSSQL = $(shell KUBECONFIG=$(K3D_CONFIG) helm list --namespace=kafka | grep mssql | cut -c 1-5)
ifeq ($(HELM_MSSQL), mssql)
	export KUBECONFIG=$(K3D_CONFIG); \
	helm upgrade mssql kubernetes/mssql-linux --namespace=kafka --values kubernetes/values/mssql.yml
else
	export KUBECONFIG=$(K3D_CONFIG); \
	helm install mssql kubernetes/mssql-linux --namespace=kafka --values kubernetes/values/mssql.yml
endif

install/charts: create/namespace cp/charts mssql/charts

.PHONY: start
start: k3d/setup install/charts

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
	export KUBECONFIG=$(K3D_CONFIG); \
	helm delete cp
	export KUBECONFIG=$(K3D_CONFIG); \
	helm delete mssql

.PHONY: tp
tp:
	# Install kafkaconnect terraform-provider
	curl -o terraform-provider-kafkaconnect.tar.gz -L https://github.com/b-social/terraform-provider-kafkaconnect/releases/download/0.9.0-rc.4/terraform-provider-kafkaconnect_v0.9.0-rc.4_$(OS)_amd64.tar.gz
	tar -xvf terraform-provider-kafkaconnect.tar.gz
	mkdir -p ~/.terraform.d/plugins/
	mv terraform-provider-kafkaconnect ~/.terraform.d/plugins/terraform-provider-kafkaconnect
	rm terraform-provider-kafkaconnect.tar.gz