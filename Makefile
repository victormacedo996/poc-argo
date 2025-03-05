.PHONY: all check-dependencies add-helm-repositories install-argo-workflow install-argocd install-spark-operator


.DEFAULT_GOAL := help


help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'

check-dependencies: ## Check dependencies
	# Checking dependency: terraform
	@terraform --version

	# Checking dependency: helm
	@helm version

	# Checking dependency: kubectl
	@kubectl version --client


add-helm-repositories: check-dependencies ## Add helm repos
	@helm repo add spark-operator https://kubeflow.github.io/spark-operator
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm repo update


install-argo-workflow: check-dependencies ## Install Argo worflows
	@helm upgrade --install argo-workflow argo-workflows \
		--repo 	https://argoproj.github.io/argo-helm \
		--namespace argo-workflow \
		--create-namespace \
		--values ./apps/argo-workflow/values.yaml \
		--version 0.45.8 \
		--wait
	@kubectl apply -f ./apps/workflow/namespace.yaml

install-argocd: check-dependencies ## Install ArgoCD
	@helm upgrade --install argocd argo-cd \
		--repo https://argoproj.github.io/argo-helm \
		--namespace argo-cd \
		--create-namespace \
		--values ./apps/argo-cd/values.yaml \
		--version 7.8.8 \
		--wait

install-spark-operator: check-dependencies ## Install Spark Operator
	@helm upgrade --install spark-operator spark-operator/spark-operator \
    	--namespace spark-operator \
		--create-namespace \
		--values ./apps/spark-operator/values.yaml \
		--wait
