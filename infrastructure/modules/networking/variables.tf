variable "project" {}
variable "region" {}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "subnetaz1" {
  description = "The AZ for the first public subnet, e.g: eu-central-1a"
  type        = "map"

  default = {
    eu-central-1 = "eu-central-1a"
  }
}

variable "subnetaz2" {
  description = "The AZ for the second public subnet, e.g: eu-central-1b"
  type        = "map"

  default = {
    eu-central-1 = "eu-central-1b"
  }
}

variable "subnetaz3" {
  description = "The AZ for the third public subnet, e.g: eu-central-1c"
  type        = "map"

  default = {
    eu-central-1 = "eu-central-1c"
  }
}

variable "subnet_cidr1" {
  description = "The CIDR block for the first public subnet, e.g: 10.0.1.0/24"
  default     = "10.0.1.0/24"
}

variable "subnet_cidr2" {
  description = "The CIDR block for the second public subnet, e.g: 10.0.2.0/24"
  default     = "10.0.2.0/24"
}

variable "subnet_cidr3" {
  description = "The CIDR block for the third public subnet, e.g: 10.0.3.0/24"
  default     = "10.0.3.0/24"
}
