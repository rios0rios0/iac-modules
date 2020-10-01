variable "region" {
  type = string
}

variable "stack" {
  type = string
}

variable "name" {
  type    = string
  default = "default"
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

variable "destroy_protection" {
  type        = bool
  description = "Destroy protection for critical environments."
}

variable "tags" {
  type        = map(string)
  description = "Default tags to attach to the resource."
}
