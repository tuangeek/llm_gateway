variable "org" {
  type        = string
  default     = "goog"
  description = "The org to name the project"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "The environment"
}

variable "vpc_id" {
  type        = string
  description = "The environment vpc"
}


variable "region" {
  type        = string
  description = "The region"
}

variable "profile" {
  type        = string
  description = "The profile"
}

# these are for the Pipeline
variable "assume_role" { default = null }

variable "role_session_name" {
  default = null
}
variable "role_session_name_commercial" {
  default = null
}