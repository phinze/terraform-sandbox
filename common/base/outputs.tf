output "ami" {
  value = "${module.ami.ami_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "public_subnet_0" {
  value = "${module.vpc.public_subnet_0}"
}

output "internal_sg" {
  value = "${module.vpc.internal_sg}"
}

output "ssh_sg" {
  value = "${aws_security_group.ssh.id}"
}

output "lb_sg" {
  value = "${aws_security_group.lb.id}"
}

output "azs" {
  value = "${module.vpc.azs}"
}

output "instance_type" {
  value = "${var.instance_type}"
}

output "key_name" {
  value = "${aws_key_pair.ssh.key_name}"
}
