
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  # AWS credentials are stored securily in a direcotory
  region = "us-east-1"

  
}

# 1. Custom VPC
resource "aws_vpc" "kubeadm_project_vpc"{

	cidr_block = "10.0.0.0/16"
	enable_dns_hostnames = true

	tags = {
		
		Name = "kubeadm_project_vpc"
	}

}

# 2. Subnet
# 3. Internet gateway
# 4. Custom route table
# 5. Associate the route table to the subnet
# 6 . create the security groups





