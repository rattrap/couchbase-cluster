variable "region" {
  description = "Region to deploy the cluster into"
  default     = "eu-central-1"
}

variable "project" {
  default = "couchbase-cluster"
}

variable "key_name" {
  default = "couchbase-cluster-key"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
