# Network Details
## CIDRs
variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                      = "10.30.0.0/16"
    SUBNET-REGIONAL-CIDR          = "10.30.10.0/24"
    LB-SUBNET-REGIONAL-CIDR       = "10.30.20.0/24"
    APIGW-FN-SUBNET-REGIONAL-CIDR = "10.30.30.0/24"
    ATP-DB-SUBNET-REGIONAL-CIDR   = "10.30.40.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR = "10.30.0.0/28"
    ALL-CIDR                      = "0.0.0.0/0"
    PODS-CIDR                     = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR       = "10.96.0.0/16"
  }
}

# OCI Provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

variable "image_operating_system" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}
variable "image_operating_system_version" {
  default     = "7.9"
  description = "The OS/image version installed on all nodes in the node pool."
}

variable "node_pool_shape" {
  default     = "VM.Standard.E3.Flex"
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node"
}
