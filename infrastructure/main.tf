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
  ami_size        = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
  min_size        = "3"
  max_size        = "3"
}

module "app" {
  source          = "./modules/autoscaling-group"
  project         = "${var.project}"
  type            = "app"
  region          = "${var.region}"
  ami_size        = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
  min_size        = "3"
  max_size        = "3"
}
