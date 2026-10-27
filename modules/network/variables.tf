variable "name" {
  description = "Name prefix"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR block (/16 recommended)"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "cidr must be a valid IPv4 CIDR block."
  }
}

variable "az_count" {
  description = "Number of availability zones to span"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "Use 2 or 3 AZs."
  }
}

variable "enable_nat" {
  description = "Create a single NAT gateway for private subnets"
  type        = bool
  default     = true
}
