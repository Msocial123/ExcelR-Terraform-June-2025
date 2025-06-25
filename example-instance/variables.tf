variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "instance_type" {
  type        = string
  default = "t2.micro"
  description = "Instance Type"
}

variable "ami_id" {
  type        = string
  default = "ami-018046b953a698135"
  description = "AMI ID"
}

variable "key_name" {
  type        = string
  default     = "Test-VPC"
  description = "Enter the Key Pair"
}
