resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name    = "${var.project} vpc"
    Project = "${var.project}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.project} igw"
    Project = "${var.project}"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr1}"
  availability_zone       = "${lookup(var.subnetaz1, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.internet_gateway"]

  tags {
    Name    = "${var.project} public subnet a"
    Project = "${var.project}"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr2}"
  availability_zone       = "${lookup(var.subnetaz2, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.internet_gateway"]

  tags {
    Name    = "${var.project} public subnet b"
    Project = "${var.project}"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr3}"
  availability_zone       = "${lookup(var.subnetaz3, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.internet_gateway"]

  tags {
    Name    = "${var.project} public subnet c"
    Project = "${var.project}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name    = "${var.project} public route table"
    Project = "${var.project}"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = "${aws_subnet.public-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_security_group" "default" {
  name        = "${var.project} default security group"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "${var.project} default security group"
    Project = "${var.project}"
  }
}

resource "aws_security_group" "public-web" {
  name        = "${var.project} public web security group"
  description = "Security group that allows web traffic from internet"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8091
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "${var.project} public web security group"
    Project = "${aws_vpc.vpc.id}"
  }
}

resource "aws_security_group" "public-ssh" {
  name        = "${var.project} public ssh security group"
  description = "Security group that allows SSH traffic from internet"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "${var.project} public ssh security group"
    Project = "${aws_vpc.vpc.id}"
  }
}
