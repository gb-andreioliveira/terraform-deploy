#Setup Provider
provider "aws" {
	profile = "default"
	region = "us-east-1"
}

terraform {
	backend "s3" {
		region  = "us-east-1"
		bucket  = "oclim-terraform-main-bucket"
		key     = "states/app_stack.tfstate"
	}
}

data "aws_vpc" "main_vpc" {
	filter {
		name   = "tag:Name"
		values = ["oclim-terraform"]
	}
}

data "aws_subnet" "subnet1" {
	filter {
		name   = "tag:Name"
		values = ["oclim-terraform-jenkins-private_subnets_a"]
	}
}

data "aws_subnet" "subnet2" {
	filter {
		name   = "tag:Name"
		values = ["oclim-terraform-jenkins-private_subnets_b"]
	}
}

data "aws_security_group" "internal_security_group" {
	filter {
		name   = "tag:Name"
		values = ["oclim-terraform-internalSG"]
	}
}

data "aws_security_group" "external_security_group" {
	filter {
		name = "tag:Name"
		values = ["oclim-terraform-externalSG"]
	}
}

module "load_balancer" {
	source = "./modules/load_balancer"
	lb_configs = [{
		name = "oclim-terraform-application-alb"
		internal = true
		load_balancer_type = "application"
		security_groups = [data.aws_security_group.internal_security_group.id]
		subnets = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
		enable_deletion_protection = false
	}]

	tg_configs = [{
		name = "oclim-terraform-application-targetgroup"
		port = 8080
		protocol = "HTTP"
		vpc_id = data.aws_vpc.main_vpc.id
		stickiness_type = "lb_cookie"
		stickiness_cookie_duration = 1800
		stickiness_enabled = true
		health_check_healthy_threshold = 3
		health_check_unhealthy_threshold = 10
		health_check_timeout = 5
		health_check_interval = 10
		health_check_path = "/"
		health_check_port = 8080
		health_check_matcher = 200
	}]

	listener_configs = [{
		port = 8080
		protocol = "HTTP"
		type = "forward"
	}]
}

module "dns" {
	source = "./modules/dns"
	configs = [{
		zone_id = "Z01996592186ORBTCJLLZ"
		name = "oclim-terraform-application"
		type = "A"
		lb_name = module.load_balancer.dns_name[0]
		lb_zone_id = module.load_balancer.lb_zone_id[0]
		evaluate_target_health = true
	}]
}

module "auto_scaling_group" {
	source = "./modules/auto_scaling_group"
	launch_configs = [{
		name_prefix = "oclim-terraform-jenkins-launchconfig-"
		image_id = "ami-0e2ff28bfb72a4e45"
		instance_type = "t2.micro"
		security_groups = [data.aws_security_group.internal_security_group.id]
		key_name = "oclim-terraform"
		iam_instance_profile = "oclim-terraform-jenkins-access-all"
	}]

	asg_configs = [{
		name = "oclim-terraform-autoscaling_group"
		min_size = 1
		max_size = 1
		availability_zones = ["us-east-1a", "us-east-1b"]
		vpc_zone_identifier = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
		health_check_type = "ELB"
		asg_instance_name = "jenkins-asg-oclim-terraform"
		target_group = module.load_balancer.target_group_arn[0]
	}]
}
