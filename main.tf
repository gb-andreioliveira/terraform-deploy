#Setup Provider
provider "aws" {
	profile = "default"
	region = "us-east-1"
}

terraform {
	backend "s3" {
		region  = "us-east-1"
		bucket  = var.bucketName
		key     = "states/app_stack.tfstate"
	}
}

data "aws_vpc" "main_vpc" {
	filter {
		name   = "tag:Name"
		values = [var.vpcName]
	}
}

data "aws_subnet" "subnet1" {
	filter {
		name   = "tag:Name"
		values = [var.subnet1]
	}
}

data "aws_subnet" "subnet2" {
	filter {
		name   = "tag:Name"
		values = [var.subnet2]
	}
}

data "aws_security_group" "internal_security_group" {
	filter {
		name   = "tag:Name"
		values = [var.internal_security_group]
	}
}

data "aws_security_group" "external_security_group" {
	filter {
		name   = "tag:Name"
		values = [var.external_security_group]
	}
}

module "app_stack" {
	source = "modules/app_stack"
	publicsubnet1_id = data.aws_subnet.subnet1.id
	publicsubnet2_id = data.aws_subnet.subnet2.id
	internal_security_group_id = data.aws_security_group.internal_security_group.id
	external_security_group_id = data.aws_security_group.external_security_group.id
	vpc_id = data.aws_vpc.main_vpc.id
}

/*module "app_ec2" {
	source = "..\/..\/modules\/app_ec2"
	s3_bucket_logs = module.s3_bucket.s3_bucket_id
	publicsubnet1_id = module.vpc_2subnets.publicsubnet1_id
	publicsubnet2_id = module.vpc_2subnets.publicsubnet2_id
	ec2_security_group_id = module.security_group.security_group_id
	vpc_id = module.vpc_2subnets.vpc_id
}*/

