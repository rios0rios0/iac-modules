variable "region" {
  type = string
}

variable "stack" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type    = string
  default = "default"
}

variable "app_settings" {
  type = map(string)
  default = {}
  description = "A key-value pair of App Settings."
}

variable "github_branch" {
  type        = string
  description = "GitHub branch of repository selected."
}

variable "github_repository" {
  type        = string
  description = "Repository of GitHub to deploy an application service to production."
}

variable "github_token" {
  type        = string
  description = "GitHub token to authenticate on private repositories."
}

variable "enable_storage_account" {
  type        = bool
  description = "Enable storage account feature for this web application."
  default     = false
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account (unique identifier for existing storage account)."
  default     = ""
}

variable "storage_account_path" {
  type        = string
  description = "The path of site to mount inside the storage container."
  default     = "/"
}

variable "storage_account_access_key" {
  type        = string
  description = "The access key for the storage account (inside access keys configuration of storage account)."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Default tags to attach to the resource."
}
