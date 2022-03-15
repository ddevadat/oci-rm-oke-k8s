# Copyright (c) 2020, 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_virtual_network" "oke_vcn" {
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_id
  display_name   = "OKE TEST VCN - ${var.deploy_id}"
  dns_label      = var.dns_label

}


resource "oci_core_internet_gateway" "oke_internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "oke-internet-gateway-${var.deploy_id}"
  enabled        = true
  vcn_id         = oci_core_virtual_network.oke_vcn.id
}

resource "oci_core_route_table" "oke_public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-public-route-table-${var.deploy_id}"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = var.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oke_internet_gateway.id
  }
}


resource "oci_core_nat_gateway" "oke_nat_gateway" {
  block_traffic  = "false"
  compartment_id = var.compartment_id
  display_name   = "oke-nat-gateway-${var.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id

}

resource "oci_core_service_gateway" "oke_service_gateway" {
  compartment_id = var.compartment_id
  display_name   = "oke-service-gateway-${var.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }

}

resource "oci_core_route_table" "oke_private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-private-route-table-${var.deploy_id}"

  route_rules {
    description       = "Traffic to the internet"
    destination       = var.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.oke_nat_gateway.id
  }
  route_rules {
    description       = "Traffic to OCI services"
    destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.oke_service_gateway.id
  }

}

resource "oci_core_subnet" "oke_k8s_endpoint_subnet" {
  cidr_block                 = var.k8s_endpoint_subnet_cidr
  compartment_id             = var.compartment_id
  display_name               = "oke-k8s-endpoint-subnet-${var.deploy_id}"
  dns_label                  = "okek8sn${var.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_endpoint_security_list.id]
}


resource "oci_core_subnet" "oke_nodes_subnet" {
  cidr_block                 = var.subnet_regional_cidr
  compartment_id             = var.compartment_id
  display_name               = "oke-nodes-subnet-${var.deploy_id}"
  dns_label                  = "okenodesn${var.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.oke_private_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_nodes_security_list.id]
}

resource "oci_core_subnet" "oke_lb_subnet" {
  cidr_block                 = var.lb_subnet_regional_cidr
  compartment_id             = var.compartment_id
  display_name               = "oke-lb-subnet-${var.deploy_id}"
  dns_label                  = "okelbsn${var.deploy_id}"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_lb_security_list.id]

}

