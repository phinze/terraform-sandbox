resource "aws_vpc" "mod" {
  cidr_block = "${var.cidr}"
  tags { Name = "${var.name}" }
  /* lifecycle { create_before_destroy = true } */
}

/* resource "aws_internet_gateway" "mod" { */
/*   vpc_id = "${aws_vpc.mod.id}" */
/* } */

/* resource "aws_route_table" "public" { */
/*   vpc_id = "${aws_vpc.mod.id}" */
/*   route { */
/*       cidr_block = "0.0.0.0/0" */
/*       gateway_id = "${aws_internet_gateway.mod.id}" */
/*   } */
/*   tags { Name = "${var.name}-public" } */
/* } */

/* resource "aws_security_group" "internal" { */
/*   vpc_id = "${aws_vpc.mod.id}" */
/*   ingress { */
/*     from_port = 0 */
/*     to_port   = 0 */
/*     protocol  = "-1" */
/*     self = true */
/*   } */
/*   egress { */
/*     from_port = 0 */
/*     to_port   = 0 */
/*     protocol  = "-1" */
/*     cidr_blocks = ["0.0.0.0/0"] */
/*   } */
/* } */

/* resource "aws_route_table" "private" { */
/*   vpc_id = "${aws_vpc.mod.id}" */
/*   tags { Name = "${var.name}-private" } */
/*   route { */
/*     cidr_block = "0.0.0.0/0" */
/*     instance_id = "${aws_instance.nat.id}" */
/*   } */
/* } */

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(split(",", var.private_subnets))}"
  tags { Name = "${var.name}-private" }
/******
 ****** vv BUG vv
 ****** Terraform v0.5.1-dev (bb3ed8d74038966beff567d1c690266744bf0316)
 ****** Hangs with this line, cycles without this line:
 ******/
  lifecycle { create_before_destroy = true }
/******
 ****** ^^ BUG ^^
 ******/
}

/* resource "aws_subnet" "public" { */
/*   vpc_id = "${aws_vpc.mod.id}" */
/*   cidr_block = "${element(split(",", var.public_subnets), count.index)}" */
/*   availability_zone = "${element(split(",", var.azs), count.index)}" */
/*   count = "${length(split(",", var.public_subnets))}" */
/*   tags { Name = "${var.name}-public" } */
/*  */
/*   map_public_ip_on_launch = true */
/*   lifecycle { create_before_destroy = true } */
/* } */

/* resource "aws_route_table_association" "private" { */
/*   count = "${length(split(",", var.private_subnets))}" */
/*   subnet_id = "${element(aws_subnet.private.*.id, count.index)}" */
/*   route_table_id = "${aws_route_table.private.id}" */
/* } */
/*  */
/* resource "aws_route_table_association" "public" { */
/*   count = "${length(split(",", var.private_subnets))}" */
/*   subnet_id = "${element(aws_subnet.public.*.id, count.index)}" */
/*   route_table_id = "${aws_route_table.public.id}" */
/* } */

/* resource "aws_instance" "nat" { */
/*   instance_type = "t2.micro" */
/*   ami = "ami-bb69128b" */
/*   /* subnet_id = "${element(aws_subnet.public.*.id, 0)}" */ */
/*   /* vpc_security_group_ids = ["${aws_security_group.internal.id}"] */ */
/*   source_dest_check = false */
/*   tags { Name = "nat" } */
/* } */

