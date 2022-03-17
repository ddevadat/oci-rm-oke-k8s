

variable "compartment_id" {}
variable "oke_vcn_id" {}
variable "oke_k8s_endpoint_subnet_id" {}
variable "oke_k8s_lb_subnet_id" {}
variable "k8s_nodes_subnet_id" {}
variable "k8s_service_cidr" {}
variable "k8s_pods_cidr" {}
variable "k8s_version" {}
variable "deploy_id" {}
variable "tenancy_ocid" {}
variable "image_id" {}




variable "node_pool_shape" {
  default     = "VM.Standard.E3.Flex"
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node"
}

variable "node_pool_boot_volume_size_in_gbs" {
  default     = "60"
  description = "Specify a custom boot volume size (in GB)"
}

variable "node_pool_name" {
  default     = "pool1"
  description = "Name of the node pool"
}

variable "num_pool_workers" {
  default     = 3
  description = "The number of worker nodes in the node pool. If select Cluster Autoscaler, will assume the minimum number of nodes configured"
}

variable "node_pool_node_shape_config_ocpus" {
  default     = "1" # Only used if flex shape is selected
  description = "You can customize the number of OCPUs to a flexible shape"
}
variable "node_pool_node_shape_config_memory_in_gbs" {
  default     = "16" # Only used if flex shape is selected
  description = "You can customize the amount of memory allocated to a flexible shape"
}

variable "generate_public_ssh_key" {
  default = true
}
variable "public_ssh_key" {
  default     = ""
  description = "In order to access your private nodes with a public SSH key you will need to set up a bastion host (a.k.a. jump box). If using public nodes, bastion is not needed. Left blank to not import keys."
}
