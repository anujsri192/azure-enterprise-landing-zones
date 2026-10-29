variable "environment" {
  description = "Target deployment environment."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region for the Landing Zone."
  type        = string
  default     = "eastus"
}

variable "prefix" {
  description = "Corporate prefix for naming all resources."
  type        = string
  default     = "corp"
}

variable "tags" {
  description = "Standard corporate enterprise tags."
  type        = map(string)
  default = {
    Environment  = "Production"
    ManagedBy    = "Terraform"
    Architecture = "Enterprise-Scale-Landing-Zone"
    Owner        = "Anuj Srivastava"
    Compliance   = "CIS-Azure-Foundations"
  }
}

