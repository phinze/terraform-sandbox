variable "asg_size" {
  default = "2"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "tftest"
}

module "base" {
  source = "../common/base"
  instance_type = "${var.instance_type}"
  ssh_public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "bastion" {
  ami = "${module.base.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${module.base.public_subnet_0}"
  vpc_security_group_ids = [
    "${module.base.ssh_sg}",
    "${module.base.internal_sg}",
  ]
  key_name = "${module.base.key_name}"
  tags {
    Name = "bastion"
  }
}

resource "aws_elb" "prod" {
  name = "tf-example-asg-immediate-roll"
  subnets = ["${split(",", module.base.public_subnets)}"]
  security_groups = [
    "${module.base.internal_sg}",
    "${module.base.lb_sg}",
  ]
  cross_zone_load_balancing = true
  connection_draining = true
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    target = "HTTP:80/"
    interval = 5
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "prod" {
  image_id = "${module.base.ami}"
  instance_type = "${module.base.instance_type}"
  security_groups = ["${module.base.internal_sg}"]
  key_name = "${module.base.key_name}"
  user_data = "${file("../common/boot.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "prod" {
  name = "${aws_launch_configuration.prod.name}"
  launch_configuration = "${aws_launch_configuration.prod.id}"
  availability_zones = ["${split(",", module.base.azs)}"]
  vpc_zone_identifier = ["${split(",", module.base.private_subnets)}"]
  load_balancers = ["${aws_elb.prod.name}"]
  max_size          = "${var.asg_size}"
  min_size          = "${var.asg_size}"
  health_check_type = "ELB"
  health_check_grace_period = 60

  lifecycle {
    create_before_destroy = true
  }
}

output "endpoint" {
  value = "${aws_elb.prod.dns_name}"
}

output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}
