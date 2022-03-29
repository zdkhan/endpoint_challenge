provider "aws" {
    region = "${var.AWS_REGION}"
}

resource "aws_vpc" "test-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
}

resource "aws_subnet" "dev-subnet-public-1" {
  vpc_id     = "${aws_vpc.test-vpc.id}"
  cidr_block = var.public_subnets
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "us-west-2a"
}
