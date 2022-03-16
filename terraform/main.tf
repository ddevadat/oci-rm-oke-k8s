# Randoms
resource "random_string" "deploy_id" {
  length  = 4
  special = false
}


module "oke" {
  source = "./modules/oke"
  # general oci parameters
  compartment_id             = var.compartment_ocid
  deploy_id                  = local.deploy_id
  oke_vcn_id                 = oci_core_virtual_network.oke_vcn.id
  oke_k8s_endpoint_subnet_id = oci_core_subnet.oke_k8s_endpoint_subnet.id
  oke_k8s_lb_subnet_id       = oci_core_subnet.oke_lb_subnet.id
  k8s_nodes_subnet_id        = oci_core_subnet.oke_nodes_subnet.id
  k8s_version                = local.cluster_k8s_latest_version
  k8s_service_cidr           = local.k8s_service_cidr
  k8s_pods_cidr              = local.k8s_pods_cidr
  tenancy_ocid               = var.tenancy_ocid
  image_id                   = local.image_id
}

resource "kubernetes_namespace" "acme_namespace" {
  metadata {
    name = "acme"
  }
  depends_on = [module.oke]
}
