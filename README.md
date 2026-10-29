<div align="center">

# 🛡️ Azure Enterprise-Scale Landing Zone (IaC)
### Microsoft Cloud Adoption Framework (CAF) Hub-and-Spoke Architecture

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure Provider](https://img.shields.io/badge/AzureRM-~%3E3.90-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![Framework](https://img.shields.io/badge/Framework-Microsoft%20CAF-00C853?style=for-the-badge&logo=shield&logoColor=white)](https://learn.microsoft.com/azure/cloud-adoption-framework/)
[![Compliance](https://img.shields.io/badge/Compliance-NIST--800--53%20%7C%20CIS-FF6F00?style=for-the-badge&logo=security&logoColor=white)](https://csrc.nist.gov/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

<p align="center">
  <strong>Architected & Maintained by <a href="https://github.com/anujsri192">Anuj Srivastava</a> — Lead DevSecOps Architect</strong>
</p>

</div>

---

## 📌 Architectural Blueprint

This repository implements a production-grade **Azure Enterprise Landing Zone** built strictly against the **Microsoft Cloud Adoption Framework (CAF)** Enterprise-Scale recommendations:

- **Management Group Hierarchy**: Structured governance hierarchy separating `Platform` (Management, Connectivity, Identity) from `Landing Zones` (Corp, Online), `Sandboxes`, and `Decommissioned` tiers.
- **Centralized Inspection Perimeter**: Hub Virtual Network hosting:
  - **Azure Firewall Premium** with Intrusion Detection and Prevention System (IDPS) and automated Threat Intelligence in `Deny` mode.
  - Dedicated `GatewaySubnet` for ExpressRoute and VPN Gateway routing.
  - Dedicated `AzureBastionSubnet` with **Azure Bastion Host** for zero-public-IP management.
- **Forced Tunneling via UDR**: Spoke workloads enforce a User Defined Route directing `0.0.0.0/0` outbound traffic directly to the Azure Firewall Private IP.
- **Bi-Directional VNet Peering**: Low-latency, high-throughput private peering between Hub and Spoke VNets with gateway transit enablement.
- **Dynamic Policy & Rule Groups**: Parameterized network and application rule collection groups utilizing HCL dynamic blocks.

---

## 🏛️ Repository Hierarchy

```bash
azure-enterprise-landing-zones/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml         # GitHub Actions CI for formatting and validation
├── modules/
│   ├── management_groups/           # CAF Management Groups hierarchy
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── hub_networking/              # Hub VNet, Firewall/Gateway/Bastion subnets, Bastion Host
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── azure_firewall/              # Azure Firewall Premium, Policy, Dynamic Rule Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── spoke_networking/            # Spoke VNet, UDR forced tunneling, bi-directional peering
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   └── prod/                        # Production orchestration parent module
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       ├── versions.tf
│       └── provider.tf
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Deployment Runbook

```bash
cd environments/prod
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## 👨‍💻 Author

**Anuj Srivastava**
- **Role**: Lead DevSecOps Architect & Enterprise Cloud Systems Engineer
- **GitHub**: [@anujsri192](https://github.com/anujsri192)
- **LinkedIn**: [Anuj Srivastava](https://www.linkedin.com/in/anujsri192)

