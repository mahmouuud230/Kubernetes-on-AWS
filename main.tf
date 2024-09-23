
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

resource "aws_internet_gateway" "kubeadm_project_igw" {

        vpc_id = aws_vpc.kubeadm_project_vpc.id

        tags = {

           Name = "kubeadm_project_igw"
        }
}

# 4. Custom route table

resource "aws_route_table" "kubeadm_project_route_table" {

	vpc_id = aws_vpc.kubeadm_project_vpc.id
	
	route {
	   cidr_block = "0.0.0.0/0"
  	   gateway_id = aws_internet_gateway.kubeadm_project_igw.id
	}

	tags = {

	   Name = "routeTable"
	}
}
# 5. Associate the route table to the subnet

resource "aws_route_table_association" "kubeadm_project_route_table_association" {
	
	subnet_id      = aws_subnet.kubeadm_project_subnet.id
	route_table_id = aws_route_table.kubeadm_project_route_table.id
}

# 6 . create the security groups

// 1. common ports (ssh/http/https)

resource "aws_security_group" "kubeadm_project_sg_common" {

	name = "kubeadm_project_sg_common"

	tags = { Name = "kubeadm_project_sg_common" }

	ingress {

	  description = "Allow HTTPS"
	  from_port = 443
	  to_port = 443
	  protocol = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]

	}

        ingress {

          description = "Allow HTTP"
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "Allow SSH"
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        egress {

          from_port = 0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]

        }

}

// 2. control plane ports
resource "aws_security_group" "kubeadm_project_sg_control_plane" {

        name = "kubeadm_project_sg_control_plane"

        tags = { Name = "kubeadm_project_sg_control_plane" }

        ingress {

          description = "Kubernetes API server"
          from_port = 6443
          to_port = 6443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "Kubelet API"
          from_port = 10250
          to_port = 10250
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "kube-scheduler"
          from_port = 10259
          to_port = 10259
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "kube-controller-manager"
          from_port = 10257
          to_port = 10257
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "Etcd_server_client_API"
          from_port = 2379
          to_port = 2380
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }
}



// 3. worker node ports

resource "aws_security_group" "kubeadm_project_sg_worker_nodes" {

        name = "kubeadm_project_sg_worker_nodes"

        tags = { Name = "kubeadm_project_sg_worker_nodes" }

        ingress {

          description = "Kubelet API "
          from_port = 10250
          to_port = 10250
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }
       
        ingress {

          description = "NodePort services"
          from_port = 30000
          to_port = 32767
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }

}

// 4. flannel UDP backend ports
resource "aws_security_group" "kubeadm_project_sg_worker_flannel" {

        name = "kubeadm_project_sg_flannel"

        tags = { Name = "kubeadm_project_sg_flannel" }

        ingress {

          description = "UDP backend "
          from_port = 8285
          to_port = 8285
          protocol = "udp"
          cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {

          description = "UDP vxlan backend "
          from_port = 8472
          to_port = 8472
          protocol = "udp"
          cidr_blocks = ["0.0.0.0/0"]

        }

}
