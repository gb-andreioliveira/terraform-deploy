variable "vpcName" {
  description = "Name of the VPC used"
  default = "oclim-terraform"
}

variable "subnet1" {
  description = "Name of the f used"
  default = "oclim-terraform-publicsubnet-1"
}

variable "subnet2" {
  description = "Name of the VPC used"
  default = "oclim-terraform-publicsubnet-2"
}

variable "internal_security_group" {
  description = "Name of the f used"
  default = "oclim-terraform-InternalSG"
}

variable "external_security_group" {
  description = "Name of the VPC used"
  default = "oclim-terraform-externalSG"
}

variable "bucketName" {
  description = "Name of the VPC used"
  default = "oclim-terraform-s3-bucket"
}