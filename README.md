# poc-argo


## Etapas

1. Instalar Argo Workflow
```
helm upgrade --install argo-workflow argo-workflows \
		--repo 	https://argoproj.github.io/argo-helm \
		--namespace argo-workflow \
		--create-namespace \
		--values ./apps/argo-workflow/values.yaml \
		--version 0.45.8 \
		--wait
kubectl apply -f ./apps/workflow/namespace.yaml # criar namespace onde serão criados os workflows
```
2. Instalar ArgoCD

```
helm upgrade --install argocd argo-cd \
    --repo https://argoproj.github.io/argo-helm \
    --namespace argo-cd \
    --create-namespace \
    --values ./apps/argo-cd/values.yaml \
    --version 7.8.8 \
    --wait
```

3. Instalar Spark Operator
```
helm upgrade --install spark-operator spark-operator/spark-operator \
    --namespace spark-operator \
    --create-namespace \
    --values ./apps/spark-operator/values.yaml \
    --wait
```

4. Instalar Argo Events
```
helm upgrade --install argo-events argo-events \
		--repo https://argoproj.github.io/argo-helm \
		--namespace argo-events \
		--create-namespace \
		--values ./apps/argo-events/values.yaml \
		--version 2.4.13 && \
kubectl apply -f ./apps/argo-events/sa.yaml
```

5. Aplicar os manifestos do argo workflow
`kubectl apply -f ./manifests/argo-workflow/notify_template.yaml`

1. Aplicar os manifestos do argo events
```
kubectl apply -f ./manifests/argo-events/event-bus.yaml && \
kubectl apply -f ./manifests/argo-events/event-source.yaml
```
1. Aplicar o Application set para syncar os workflows
`kubectl apply -f ./manifests/argocd/applicationset.yaml`


Senha inicial ArgoCD
`kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
Portforward ArgoCD
`kubectl port-forward service/argocd-server -n argo-cd 8080:443`

Portforward argo workflow
`kubectl port-forward service/argo-workflow-argo-workflows-server 2746:2746 -n argo-workflow`