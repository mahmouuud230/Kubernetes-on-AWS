variable "kubeadm_project_key_name" {

	type = string
	description = "Name of our keypair"
	default = "kubeadm_project_key"
}

variable "kubeadm_project_ami" {

        type = string
        description = "Ami for ubuntu image"
        default = "ami-0a0e5d9c7acc336f1"
}

variable "kubeadm_project_instance_count" {

	type = number
	description = "The number of worker nodes in the cluster"
	default = 2

}
