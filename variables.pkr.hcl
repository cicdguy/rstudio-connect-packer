variable "aws_region" {
  description = "AWS Region where the AMI will be created"
  type        = string
  default     = "us-east-1"
}

variable "r_version" {
  description = "Version of R to install on AMI"
  type        = string
  default     = "4.0.3"
}

variable "rstudio_connect_version" {
  description = "Version of RStudio Connect to install on AMI"
  type        = string
  default     = "1.8.6.2"
}
