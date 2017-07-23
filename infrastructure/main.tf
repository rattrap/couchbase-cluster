provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

module "networking" {
  source  = "./modules/networking"
  project = "${var.project}"
  region  = "${var.region}"
}

module "couchbase" {
  source          = "./modules/autoscaling-group"
  project         = "${var.project}"
  type            = "couchbase"
  region          = "${var.region}"
  ami_size        = "c3.8xlarge"
  key_name        = "${var.key_name}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
  load_balancers  = []
  min_size        = "6"
  max_size        = "6"
}

module "load-balancer" {
  source          = "./modules/load-balancer"
  project         = "${var.project}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
}

module "app" {
  source          = "./modules/autoscaling-group"
  project         = "${var.project}"
  type            = "app"
  region          = "${var.region}"
  ami_size        = "c3.8xlarge"
  key_name        = "${var.key_name}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
  load_balancers  = ["${module.load-balancer.name}"]
  min_size        = "6"
  max_size        = "6"
}

output "dns-name" {
  value = "${module.load-balancer.dns-name}"
}
