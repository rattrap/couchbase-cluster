provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "aws_ami" "amazonlinux" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}

module "networking" {
  source  = "./modules/networking"
  project = "${var.project}"
  region  = "${var.region}"
}

module "couchbase" {
  source          = "./modules/couchbase"
  project         = "${var.project}"
  region          = "${var.region}"
  ami_id          = "${data.aws_ami.amazonlinux.image_id}"
  ami_size        = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${module.networking.security_groups}"]
  subnets         = ["${module.networking.subnets}"]
  min_size        = "1"
  max_size        = "1"
}
