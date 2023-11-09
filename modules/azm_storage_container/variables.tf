variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
  default     = "default-rg"
}

variable "storage_account_name" {
  type        = string
  description = "The unique name of the company owner of provider account."
}

variable "storage_container_name" {
  type        = string
  description = "The name of the storage container."
  default     = "terraform-tfstates"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to attach to the resource."
}
