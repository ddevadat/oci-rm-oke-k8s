

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
