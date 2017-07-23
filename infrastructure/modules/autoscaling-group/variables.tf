variable "project" {}
variable "type" {}
variable "region" {}
variable "ami_size" {}
variable "key_name" {}

variable "security_groups" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "min_size" {}
variable "max_size" {}

variable "load_balancers" {
  type = "list"
}
