resource "aws_elastic_beanstalk_application" "test_beanstalk_application" {
  name        = "${var.application_name}"
  description = "${var.application_description}"
}

resource "aws_elastic_beanstalk_environment" "test_beanstalk_application_environment" {
  name                = "${var.application_name}-${var.application_environment}"
  application         = "${aws_elastic_beanstalk_application.test_beanstalk_application.name}"
  solution_stack_name = "64bit Amazon Linux 2016.09 v2.5.1 running Docker 1.12.6"
  tier                = "WebServer"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.test_beanstalk_ec2.name}"
  }
}


resource "aws_ecr_repository" "test_container_repository" {
  name = "${var.application_name}"
}

# Beanstalk instance profile
resource "aws_iam_instance_profile" "test_beanstalk_ec2" {
  name  = "test-beanstalk-ec2-user"
  role  = aws_iam_role.test_beanstalk_ec2.name
}

resource "aws_iam_role" "test_beanstalk_ec2" {
  name = "test-beanstalk-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Beanstalk EC2 Policy
# Overriding because by default Beanstalk does not have a permission to Read ECR
resource "aws_iam_role_policy" "test_beanstalk_ec2_policy" {
  name = "ng_beanstalk_ec2_policy_with_ECR"
  role = "${aws_iam_role.test_beanstalk_ec2.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "ds:CreateComputer",
        "ds:DescribeDirectories",
        "ec2:DescribeInstanceStatus",
        "logs:*",
        "ssm:*",
        "ec2messages:*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "my_app_ebs" {
  bucket = "my-app-ebs"
  acl    = "private"

  tags = {
    Name = "My APP EBS"
  }
}

resource "aws_s3_bucket_object" "my_app_deployment" {
  bucket = aws_s3_bucket.my_app_ebs.id
  key    = "Dockerrun.aws.json"
  source = "Dockerrun.aws.json"
}
