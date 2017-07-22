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

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix   = "${var.project}-${var.type}-node-"
  image_id      = "${data.aws_ami.amazonlinux.image_id}"
  instance_type = "${var.ami_size}"

  security_groups = ["${var.security_groups}"]

  lifecycle {
    create_before_destroy = true
  }

  key_name = "${var.key_name}"
}

resource "aws_autoscaling_group" "autoscaling_group" {
  depends_on           = ["aws_launch_configuration.launch_configuration"]
  name                 = "${var.project} ${var.type} autoscaling group"
  launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project} ${var.type} node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }
}
