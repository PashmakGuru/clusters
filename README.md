# Readme for Platform Cloud Resources

[![Clusters: Run Terraform](https://github.com/PashmakGuru/platform-cloud-resources/actions/workflows/clusters-sync.yaml/badge.svg)](https://github.com/PashmakGuru/platform-cloud-resources/actions/workflows/clusters-sync.yaml)
[![Fronthub: Run Terraform](https://github.com/PashmakGuru/platform-cloud-resources/actions/workflows/fronthub-sync.yaml/badge.svg)](https://github.com/PashmakGuru/platform-cloud-resources/actions/workflows/fronthub-sync.yaml)

## Overview

This repository is dedicated to managing cloud resources, specifically for Azure, using Terraform. It facilitates cloud-related self-service actions within the Internal Developer Platform (IDP) of [Port](https://getport.io/).

### Capabilities
- [x] Management of Kubernetes clusters.
- [x] Management of domains and DNS zones.
- [x] Management of dedicated endpoints for clusters.

### Integration
- [Port](https://app.getport.io/)
- [Azure](https://azure.microsoft.com/en-us)

### Tools and Modules
- [Platform Orchestrator (GitHub Actions)](https://github.com/PashmakGuru/gha-platform-orchestrator)
- [Kubernetes Cluster (Terraform Module)](https://github.com/PashmakGuru/terraform-azure-kubernetes-cluster)
- [Fronthub (Terraform Module)](https://github.com/pashmakGuru/terraform-azure-fronthub)

## Architecture
### Sequence of Cluster Management
```mermaid
sequenceDiagram
    actor PLE as Platform Engineer
    participant PRT as Port IDP
    participant RCR as Repository:<br>platform-cloud-resources
    participant RPO as Repository:<br>platform-orchestrator
    participant TFC as Terraform Cloud
    participant MKC as Terraform Module:<br>azure-kubernetes-cluster
    participant AZR as Azure

    PLE ->> PRT: Add or delete clusters
    PRT ->> RCR: Initiate workflow:<br>clusters-modify.yaml

    activate RCR
    RCR ->>RPO: Call modifier action
    activate RPO
    RPO -->>RCR: Modify `clusters.json`
    deactivate RPO
    RCR ->> RCR: Commit and push changes
    deactivate RCR

    RCR ->>RCR: Initiate workflow:<br>clusters-sync.yaml

    activate RCR
    RCR ->> TFC: Plan and apply
    TFC ->>MKC: Use module
    MKC ->> AZR: Change to desired state
    activate AZR
    AZR -->> MKC: Return outputs
    deactivate AZR
    MKC -->>TFC: Return outputs
    TFC ->> PRT: Upsert/delete cluster entities
    deactivate RCR
```

### Sequence of DNS Zone Management
```mermaid
sequenceDiagram
    actor PLE as Platform Engineer
    participant PRT as Port IDP
    participant RCR as Repository:<br>platform-cloud-resources
    participant RPO as Repository:<br>platform-orchestrator
    participant TFC as Terraform Cloud
    participant MFH as Terraform Module:<br>azure-front-hub
    participant AZR as Azure

    PLE ->> PRT: Add or delete domains
    PRT ->> RCR: Initiate workflow:<br>fronthub-modify-dns-zone.yaml

    activate RCR
    RCR ->>RPO: Call modifier action
    activate RPO
    RPO -->>RCR: Modify `fronthub.json`
    deactivate RPO
    RCR ->>RPO: Call transformer action
    activate RPO
    RPO -->>RCR: Transform `fronthub.json`<br>to `fronthub.lock.json`
    deactivate RPO
    RCR ->> RCR: Commit and push changes
    deactivate RCR

    RCR ->>RCR: Initiate workflow:<br>fronthub-sync.yaml

    activate RCR
    RCR ->> TFC: Plan and apply
    TFC ->> MFH: Use module
    MFH ->> AZR: Change to desired state
    activate AZR
    AZR -->>MFH: Return outputs
    deactivate AZR
    MFH -->>TFC: Return outputs
    TFC ->>PRT: Upsert/delete domain (with relevant nameservers) and endpoint entities
    deactivate RCR
```

### Sequence of Endpoint Management
```mermaid
sequenceDiagram
    actor PLE as Platform Engineer
    participant PRT as Port IDP
    participant RCR as Repository:<br>platform-cloud-resources
    participant RPO as Repository:<br>platform-orchestrator
    participant TFC as Terraform Cloud
    participant MFH as Terraform Module:<br>azure-front-hub
    participant AZR as Azure

    PLE ->> PRT: Add or delete endpoints
    PRT ->> RCR: Initiate workflow:<br>fronthub-modify-dns-zone.yaml

    activate RCR
    RCR ->>RPO: Call modifier action
    activate RPO
    RPO ->> PRT: Fetch endpoint's target cluster info
    PRT -->>RPO: Return data
    RPO -->>RCR: Modify `fronthub.json`
    deactivate RPO
    RCR ->>RPO: Call transformer action
    activate RPO
    RPO -->>RCR: Transform `fronthub.json`<br>to `fronthub.lock.json`
    deactivate RPO
    RCR ->> RCR: Commit and push changes
    deactivate RCR

    RCR ->>RCR: Initiate workflow:<br>fronthub-sync.yaml

    activate RCR
    RCR ->> TFC: Plan and apply
    TFC ->> MFH: Use module
    MFH ->> AZR: Change to desired state
    activate AZR
    AZR -->>MFH: Return outputs
    deactivate AZR
    MFH -->>TFC: Return outputs
    TFC ->>PRT: Upsert/delete domain (with relevant nameservers) and endpoint entities
    deactivate RCR
```

## Components

- **Clusters**: The [clusters](clusters/) directory focuses on managing Kubernetes Clusters on Azure (AKS) using the terraform-azure-kubernetes-cluster module.
- **Fronthub**: The [fronthub](fronthub/) directory deals with Azure DNS Zones and endpoint management for Azure Front Door, assigning subdomains or paths to specific clusters.

## Workflows

| Name                                | Description                                                                                                                                      |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| [clusters-modify.yaml](.github/workflows/clusters-modify.yaml) | Modifies [clusters.json](clusters/clusters.json) as per Port's instructions, followed by committing and pushing changes.                       |
| [clusters-sync.yaml](.github/workflows/clusters-sync.yaml)     | Executes terraform to provision or synchronize clusters.                                                                                         |
| [fronthub-modify-dns-zone.yaml](.github/workflows/fronthub-modify-dns-zone.yaml) | Alters [fronthub.json](fronthub/fronthub.json) for domain management based on Port's guidance, updates [fronthub.lock.json](fronthub/fronthub.lock.json), and commits and pushes changes. |
| [fronthub-modify-endpoint.yaml](.github/workflows/fronthub-modify-endpoint.yaml) | Adjusts [fronthub.json](fronthub/fronthub.json) for endpoint management as per Port's instructions, followed by committing and pushing the final configuration. |
| [fronthub-manual-transform.yaml](.github/workflows/fronthub-manual-transform.yaml) | Manually triggered to transform [fronthub.json](fronthub/fronthub.json) to its final configuration, with subsequent commit and push operations. |
| [fronthub-sync.yaml](.github/workflows/fronthub-sync.yaml)     | Runs terraform to provision or update Azure DNS Zones and Front Door endpoints.
