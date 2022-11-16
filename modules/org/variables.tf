variable "org_name" {
  type        = string
  description = "The name of your organization"
}

variable "org_identifier" {
  type        = string
  description = "The unique identifier of your organization"
  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]+", var.org_identifier))
    error_message = "The ID must start with an alphabetic character, and may contain numbers or underscores"
  }
}