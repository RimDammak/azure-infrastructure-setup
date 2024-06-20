variable "name" {
  type        = string
  description = "Name for this ressource group"
}

variable "location" {
  type        = string
  description = "Name of the region for this infrastructure"
  default     = "North Europe"
}

variable "address_space" {
  type        = string
  description = "Cidr range for the Virtual Network"
  default     = "10.10.0.0/16"
}

