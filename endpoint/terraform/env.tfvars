vpc_cidr                  = "10.0.0.0/16"
azs                       = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
public_subnets            = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
application_description   = "test app"
application_environment   = "dev"
application_name          = "kibana" 
