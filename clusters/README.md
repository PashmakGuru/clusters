# Clusters

A Terraform app that manages our AKS clusters in a GitOps manner. It can be contributed manually or updated via Port self-service feature.

An example structure of `input-port.json`:
```json
{
  "clusters": [
    {
      "name": "foobarrrrr",
      "resource_group_name": "kubernetes-solution-foobarrrrr-testing",
      "resource_group_location": "West US 3",
      "environment": "testing"
    }
  ]
}

```
