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

data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_security_list" "oke_endpoint_security_list" {
  compartment_id = var.compartment_id
  display_name   = "oke-k8s-api-endpoint-seclist-${var.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id

  # Ingresses

  ingress_security_rules {
    description = "External access to Kubernetes API endpoint"
    source      = var.all_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.k8s_api_endpoint_port_number
      min = local.k8s_api_endpoint_port_number
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    source      = var.subnet_regional_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.k8s_api_endpoint_port_number
      min = local.k8s_api_endpoint_port_number
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to control plane communication"
    source      = var.subnet_regional_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.k8s_worker_to_control_plane_port_number
      min = local.k8s_worker_to_control_plane_port_number
    }
  }
  ingress_security_rules {
    description = "Path discovery"
    source      = var.subnet_regional_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.icmp_protocol_number
    stateless   = false

    icmp_options {
      type = "3"
      code = "4"
    }
  }

  # Egresses

  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false

    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }
  egress_security_rules {
    description      = "All traffic to worker nodes"
    destination      = var.subnet_regional_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.subnet_regional_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.icmp_protocol_number
    stateless        = false

    icmp_options {
      type = "3"
      code = "4"
    }
  }

}

################################################################

resource "oci_core_security_list" "oke_nodes_security_list" {
  compartment_id = var.compartment_id
  display_name   = "oke-nodes-wkr-seclist-${var.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id

  # Ingresses
  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
    source      = var.subnet_regional_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.all_protocols
    stateless   = false
  }
  ingress_security_rules {
    description = "Inbound SSH traffic to worker nodes"
    source      = var.all_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.ssh_port_number
      min = local.ssh_port_number
    }
  }
  ingress_security_rules {
    description = "TCP access from Kubernetes Control Plane"
    source      = var.k8s_endpoint_subnet_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false
  }
  ingress_security_rules {
    description = "Path discovery"
    source      = var.k8s_endpoint_subnet_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.icmp_protocol_number
    stateless   = false

    icmp_options {
      type = "3"
      code = "4"
    }
  }

  # Egresses
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination      = var.subnet_regional_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.all_protocols
    stateless        = false
  }
  egress_security_rules {
    description      = "Worker Nodes access to Internet"
    destination      = var.all_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.all_protocols
    stateless        = false
  }
  egress_security_rules {
    description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false

    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }
  egress_security_rules {
    description      = "ICMP Access from Kubernetes Control Plane"
    destination      = var.all_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.icmp_protocol_number
    stateless        = false

    icmp_options {
      type = "3"
      code = "4"
    }
  }
  egress_security_rules {
    description      = "Access to Kubernetes API Endpoint"
    destination      = var.k8s_endpoint_subnet_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false

    tcp_options {
      max = local.k8s_api_endpoint_port_number
      min = local.k8s_api_endpoint_port_number
    }
  }
  egress_security_rules {
    description      = "Kubernetes worker to control plane communication"
    destination      = var.k8s_endpoint_subnet_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false

    tcp_options {
      max = local.k8s_worker_to_control_plane_port_number
      min = local.k8s_worker_to_control_plane_port_number
    }
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.k8s_endpoint_subnet_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.icmp_protocol_number
    stateless        = false

    icmp_options {
      type = "3"
      code = "4"
    }
  }

}

#########################################################################

resource "oci_core_security_list" "oke_lb_security_list" {
  compartment_id = var.compartment_id
  display_name   = "oke-lb-seclist-${var.deploy_id}"
  vcn_id         = oci_core_virtual_network.oke_vcn.id

}


