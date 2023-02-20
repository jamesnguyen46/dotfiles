# Kubernetes aliases

- [Config file](../configs/aliases/kubernetes_aliases.sh)

## Common

## Context and configuration

## Config map & secret

## Namespace



## Deployment

| Alias | Command                                                               | Description                                                                                                   |
| ----- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `kgd` | `kubectl get deployment -n <namespace>`                               | List all deployments in namespace                                                                             |
| `kgd` | `kubectl rollout restart deployment <deployment_name> -n <namespace>` | Rolling restart of a particular deployment in namespace. If `deployment_name` is not specify then restart all |

## Pod

| Alias             | Command                                         | Description                |
| ----------------- | ----------------------------------------------- | -------------------------- |
| `kgp <namespace>` | `kubectl get pods -n <namespace>`               | List all pods in namespace |
| `kdp <pod_name>`  | `kubectl delete pod <pod_name> -n <namespace>`  | Delete a pod in namespace  |
| `kex`             | `kubectl -n <namespace> exec -it <pod_name> sh` | Exec to a pod              |

## References

- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
