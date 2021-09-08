variable "name" {
  type        = string
  description = "Name of role"
}

variable "path" {
  type        = string
  default = "/"
  description = "Path to the role"
}

variable "assumable_type" {
  type        = string
  description = "Type of service that will assume role (`external` for extrnal account `internal` for internal account or `service` for AWS Service)"
}

variable "assumable_identifier" {
  type        = string
  description = "Id of service that will assume role or ARN of external entity"
}

variable "assumable_additional_id" {
  type        = string
  default     = null
  description = "Id of external account for additional verification"
}

variable "policy_arns" {
  type        = list(string)
  default     = []
  description = "Policies to attach"
}

variable "policy_documents" {
  type        = list(string)
  default     = []
  description = "Policy documents to attach"
}
