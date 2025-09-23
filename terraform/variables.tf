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

