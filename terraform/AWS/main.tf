provider "aws" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.vpc_name}-${var.availability_zone}-public"
    Description = "${var.vpc_name} public subnet in AZ ${var.availability_zone}"
  }
}

resource "aws_instance" "bastion" {

  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "amaury_aws"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.bastions.id}"]

  associate_public_ip_address = true

  tags {
    Name = "training-${var.vpc_name}-${var.availability_zone}"
  }
}
resource "aws_instance" "worknode" {
  count = 6
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "amaury_aws"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.bastions.id}"]

  associate_public_ip_address = false

  tags {
    Name = "${var.vpc_name}-${count.index}-${var.availability_zone}"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "InternetGateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "public_subnet_eu_west_1a_association" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}


resource "aws_security_group" "bastions" {
  name = "service_bastions"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
