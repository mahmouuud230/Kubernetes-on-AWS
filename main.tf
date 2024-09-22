
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  # AWS credentials are stored securely in the ~/.aws/credentials file.
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

resource "aws_subnet" "kubeadm_project_subnet" {

	vpc_id = aws_vpc.kubeadm_project_vpc.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = true

	tags = {
	
	   Name = "kubeadm_project_subnet"
	}

}

# 3. Internet gateway
# 4. Custom route table
# 5. Associate the route table to the subnet
# 6 . create the security groups





