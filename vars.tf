variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMI" {
  type = map(any)
  default = {
    us-east-1 = "ami-0aeeebd8d2ab47354"
  }
}

variable "PRIVATE_KEY_PATH" {
  default = "kpacgecc"
}

variable "PUBLIC_KEY_PATH" {
  default = "kpacgecc.pub"
}

variable "EC2_USER" {
  default = "ec2-user"
}