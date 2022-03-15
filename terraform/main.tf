# Randoms
resource "random_string" "deploy_id" {
  length  = 4
  special = false
}

module "network" {
  source = "./modules/network"

  # general oci parameters
  compartment_id           = var.compartment_ocid
  dns_label                = "oke${random_string.deploy_id.result}"
  deploy_id                = random_string.deploy_id.result
  display_name             = "OKE TEST VCN1"
  cidr_block               = lookup(var.network_cidrs, "VCN-CIDR")
  k8s_endpoint_subnet_cidr = lookup(var.network_cidrs, "ENDPOINT-SUBNET-REGIONAL-CIDR")
  all_cidr                 = lookup(var.network_cidrs, "ALL-CIDR")
  subnet_regional_cidr     = lookup(var.network_cidrs, "SUBNET-REGIONAL-CIDR")
  lb_subnet_regional_cidr  = lookup(var.network_cidrs, "LB-SUBNET-REGIONAL-CIDR")


}


# module "oke" {
#   source = "./modules/oke"
#   # general oci parameters
#   compartment_id             = var.compartment_ocid
#   deploy_id                  = random_string.deploy_id.result
#   oke_vcn_id                 = module.network.vcn_id
#   oke_k8s_endpoint_subnet_id = module.network.k8s_endpoint_subnet_id
#   oke_k8s_lb_subnet_id       = module.network.k8s_lb_subnet_id
#   k8s_nodes_subnet_id        = module.network.k8s_nodes_subnet_id
#   k8s_version                = local.cluster_k8s_latest_version
#   k8s_service_cidr           = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
#   k8s_pods_cidr              = lookup(var.network_cidrs, "PODS-CIDR")
#   tenancy_ocid               = var.tenancy_ocid
#   image_id                   = lookup(data.oci_core_images.node_pool_images.images[0], "id")
# }

# resource "kubernetes_namespace" "acme_namespace" {
#   metadata {
#     name = "acme"
#   }
#   depends_on = [module.oke]
# }
