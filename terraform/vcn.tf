resource "oci_core_virtual_network" "oke_vcn" {
  cidr_block     = local.cidr_block
  compartment_id = var.compartment_ocid
  display_name   = "OKE TEST VCN - ${local.deploy_id}"
  dns_label      = "oke${local.deploy_id}"

}

resource "oci_core_internet_gateway" "oke_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "oke-internet-gateway-${local.deploy_id}"
  enabled        = true
  vcn_id         = oci_core_virtual_network.oke_vcn.id
}

resource "oci_core_route_table" "oke_public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-public-route-table-${local.deploy_id}"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = local.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oke_internet_gateway.id
  }
}


resource "oci_core_nat_gateway" "oke_nat_gateway" {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
  display_name   = "oke-nat-gateway-${local.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id

}

resource "oci_core_service_gateway" "oke_service_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "oke-service-gateway-${local.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  services {
    service_id = local.service_id
  }

}

resource "oci_core_route_table" "oke_private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-private-route-table-${local.deploy_id}"

  route_rules {
    description       = "Traffic to the internet"
    destination       = local.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.oke_nat_gateway.id
  }
  route_rules {
    description       = "Traffic to OCI services"
    destination       = local.service_cidr
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.oke_service_gateway.id
  }

}

resource "oci_core_subnet" "oke_k8s_endpoint_subnet" {
  cidr_block                 = local.k8s_endpoint_subnet_cidr
  compartment_id             = var.compartment_ocid
  display_name               = "oke-k8s-endpoint-subnet-${local.deploy_id}"
  dns_label                  = "okek8sn${local.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_endpoint_security_list.id]
}


resource "oci_core_subnet" "oke_nodes_subnet" {
  cidr_block                 = local.subnet_regional_cidr
  compartment_id             = var.compartment_ocid
  display_name               = "oke-nodes-subnet-${local.deploy_id}"
  dns_label                  = "okenodesn${local.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.oke_private_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_nodes_security_list.id]
}

resource "oci_core_subnet" "oke_lb_subnet" {
  cidr_block                 = local.lb_subnet_regional_cidr
  compartment_id             = var.compartment_ocid
  display_name               = "oke-lb-subnet-${local.deploy_id}"
  dns_label                  = "okelbsn${local.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_lb_security_list.id]

}










# module "network" {
#   source = "./modules/network"

#   # general oci parameters
#   compartment_id           = var.compartment_ocid
#   dns_label                = "oke${random_string.deploy_id.result}"
#   deploy_id                = random_string.deploy_id.result
#   display_name             = "OKE TEST VCN"
#   cidr_block               = lookup(var.network_cidrs, "VCN-CIDR")
#   k8s_endpoint_subnet_cidr = lookup(var.network_cidrs, "ENDPOINT-SUBNET-REGIONAL-CIDR")
#   all_cidr                 = lookup(var.network_cidrs, "ALL-CIDR")
#   subnet_regional_cidr     = lookup(var.network_cidrs, "SUBNET-REGIONAL-CIDR")
#   lb_subnet_regional_cidr  = lookup(var.network_cidrs, "LB-SUBNET-REGIONAL-CIDR")


# }


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
