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


variable "container_port" {
  type        = string
  default     = 8080
  description = "The container port"
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "The number of task to run"
}