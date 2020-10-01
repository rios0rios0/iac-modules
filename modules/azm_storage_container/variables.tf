variable "region" {
  type = string
}

variable "company_unique" {
  type        = string
  description = "The unique name of the company owner of provider account."
}

variable "tags" {
  type        = map(string)
  description = "Default tags to attach to the resource."
}
