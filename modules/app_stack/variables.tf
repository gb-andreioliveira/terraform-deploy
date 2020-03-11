variable "app_instanceA_name" {
  description = "Name for the Jenkins EC2 Instance A"
  default = "app-oclim-terraform"
}

variable "app_instanceB_name" {
  description = "Name for the Jenkins EC2 Instance B"
  default = "app-B-oclim-terraform-publicsubnet2"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-07d11744b62c23c51"
}

variable "jumpserver_ami" {
  description = "AMI for the EC2 instance for jumping"
  default = "ami-07d11744b62c23c51"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}

variable "publicsubnet1_id" {
  description = "Subnet ID used by the privatesubnet1 instance"
  default = "127.0.0.1"
}

variable "publicsubnet2_id" {
  description = "Subnet ID used by the privatesubnet2 instance"
  default = "127.0.0.1"
}

variable "internal_security_group_id" {
  description = "Subnet ID used by the privatesubnet2 instance"
  default = "127.0.0.1"
}

variable "external_security_group_id" {
  description = "Subnet ID used by the privatesubnet2 instance"
  default = "127.0.0.1"
}

variable "loadbalancer_name" {
  description = "Name for the Application Load Balancer"
  default = "oclim-terraform-app-alb"
}

variable "loadbalancer_internal" {
  description = "Internal or External setting for the Application Load Balancer"
  default = true
}

variable "launchconfig_lifecycle" {
  description = "Defines the lifecycle for the launch config"
  default = true
}

variable "autoscalinggroup_minsize" {
  description = "Defines the mininum size for the auto scaling group"
  default = 4
}

variable "autoscalinggroup_maxsize" {
  description = "Defines the maximum size for the auto scaling group"
  default = 8
}

variable "loadbalancer_type" {
  description = "Type of Application Load Balancer"
  default = "application"
}

variable "loadbalancer_deleteprotection" {
  description = "Enables the deletion protection of Application Load Balancer"
  default = false
}

variable "loadbalancer_accesslogs" {
  description = "Enables the access logging of Application Load Balancer"
  default = true
}

variable "loadbalancer_accesslogs_prefix" {
  description = "Prefix for logs of Application Load Balancer"
  default = "logs"
}

variable "app_alb_port" {
  description = "Port for the listener of Application Load Balancer"
  default = 8080
}

variable "app_healthcheck_responsecode" {
  description = "Response code status for the listener of Application Load Balancer"
  default = 200
}

variable "app_alb_protocol" {
  description = "Protocol for the listener of Application Load Balancer"
  default = "HTTP"
}

variable "app_alb_targetgroup_name" {
  description = "Application Load Balancer Target Group Name"
  default = "oclim-terraform-app-targetgroup"
}

variable "app_alb_targetgroup_cookie_type" {
  description = "Application Load Balancer Target Cookie Type"
  default = "lb_cookie"
}

variable "app_alb_targetgroup_sticky" {
  description = "Enables the sticky setting of Application Load Balancer"
  default = true
}

variable "app_alb_targetgroup_cookie_duration" {
  description = "Sets the duration of cookie of Application Load Balancer"
  default = 1800
}

variable "app_alb_targetgroup_healthy_threshold" {
  description = "Sets the healthy treshold of Application Load Balancer"
  default = 3
}

variable "app_alb_targetgroup_unhealthy_threshold" {
  description = "Sets the unhealthy treshold of Application Load Balancer"
  default = 10
}

variable "app_alb_targetgroup_timeout" {
  description = "Sets the timeout of Application Load Balancer"
  default = 5
}

variable "app_alb_targetgroup_interval" {
  description = "Sets the interval of Application Load Balancer"
  default = 10
}

variable "app_alb_targetgroup_path" {
  description = "Sets the path of cookie of Application Load Balancer"
  default = "/"
}

variable "app_alb_listener_type" {
  description = "Sets the type of Application Load Balancer listener"
  default = "forward"
}

variable "s3_bucket_logs" {
  description = "Bucket in which to store access logs"
  default = "127.0.0.1"
}

variable "vpc_id" {
  description = "ID for the VPC attached to this security group"
  default = "none"
}

variable "vpcname" {
  description = "Name for the VPC"
  default = "oclim-app-terraform"
}

variable "instance_key" {
  description = "Key to be used on the instances"
  default = "oclim-terraform"
}

variable "availability_zone1" {
  description = "availability zone to create subnet"
  default = "us-east-1a"
}

variable "availability_zone2" {
  description = "availability zone to create subnet"
  default = "us-east-1b"
}

variable "app_alb_policy" {
  description = "SSL Policy"
  default = "ELBSecurityPolicy-2016-08"
}

variable "app_asg_healthchecktype" {
  description = "health check typefor auto scaling group"
  default = "ELB"
}


variable "app_asg_placement_group_strategy" {
  description = "health check for the Application Load Balancer"
  default = "cluster"
}

variable "app_lb_zoneid" {
  description = "Zone ID for the Load Balancer"
  default = "Z01996592186ORBTCJLLZ"
}

variable "lb_name" {
  description = "Name for the Load Balancer"
  default = "app-oclim-terraform"
}

variable "lb_type" {
  description = "Record Type"
  default = "A"
}

variable "lb_ttl" {
  description = "Record TTL"
  default = 300
}

variable "app_launchconfig_prefix" {
  description = "Prefix for the launch config machines"
  default = "app-lc-oclim-terraform-"
}

variable "asg_key" {
  description = "Key for tags on ASG"
  default = "Name"
}

variable "asg_value" {
  description = "Value for tags on ASG"
  default = "asg-app-oclim-terraform"
}

variable iam_instance_profile {
  description = "Value for IAM Instance Role to be attached"
  default = "oclim-terraform-jenkins-access-all"
}

variable "user_data" {
  description = "Data to use when starting the app"
  default = <<EOT
    #!/bin/bash
    aws s3 cp s3://oclim-terraform-s3-bucket/app_oclim.zip ~/app.zip
    unzip ~/app.zip -d ~/app
    mkdir ~/app/test-reports/
    python ~/app/test.py
    python ~/app/test.py
    ls -lah ~/app/test-reports/
    aws s3 cp ~/app/test-reports/ s3://oclim-terraform-s3-bucket/test-reports/ --exclude "*" --include "*.xml" --recursive
    python ~/app/app.py &
  EOT

}