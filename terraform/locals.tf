locals {
  cluster_k8s_latest_version = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
  #   node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.oke.kubernetes_versions))[0]
  deploy_id                = random_string.deploy_id.result
  cidr_block               = lookup(var.network_cidrs, "VCN-CIDR")
  k8s_endpoint_subnet_cidr = lookup(var.network_cidrs, "ENDPOINT-SUBNET-REGIONAL-CIDR")
  all_cidr                 = lookup(var.network_cidrs, "ALL-CIDR")
  subnet_regional_cidr     = lookup(var.network_cidrs, "SUBNET-REGIONAL-CIDR")
  lb_subnet_regional_cidr  = lookup(var.network_cidrs, "LB-SUBNET-REGIONAL-CIDR")
  service_id               = lookup(data.oci_core_services.all_services.services[0], "id")
  service_cidr             = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
  k8s_service_cidr         = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
  k8s_pods_cidr            = lookup(var.network_cidrs, "PODS-CIDR")
  image_id                 = lookup(data.oci_core_images.node_pool_images.images[0], "id")
}

locals {
  http_port_number                        = "80"
  https_port_number                       = "443"
  k8s_api_endpoint_port_number            = "6443"
  k8s_worker_to_control_plane_port_number = "12250"
  ssh_port_number                         = "22"
  atp_db_port_number                      = "1522"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"
}
