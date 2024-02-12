variable "sku" {
  type        = string
  description = "The SKU name of the Azure Container Registry."
}

variable "name" {
  type        = string
  description = "The name of the Azure Container Registry."
}

variable "location" {
  type        = string
  description = "The location/region in which to create the Azure Container Registry."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure Container Registry."
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to all resources in this module."
}
