variable "AWS_REGION" {
  description = "Default region to build infrastructure in."
  type        = string
  default     = "us-west-2"
}

variable "application_name" {
  description = "Name of your application"
  type        = string
  default     = "kibana"
}

variable "application_description" {
  description = "Sample application based on Elastic Beanstalk & Docker"
  type        = string
  default     = "test app"
}

variable "application_environment" {
  description = "Deployment stage e.g. 'staging', 'production', 'test', 'integration'"
  type        = string
  default     = "dev"
}
