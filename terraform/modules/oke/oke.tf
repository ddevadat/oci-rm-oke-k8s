
resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "TEST-OKE-${var.deploy_id}"
  vcn_id             = var.oke_vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.oke_k8s_endpoint_subnet_id
  }
  options {
    service_lb_subnet_ids = [var.oke_k8s_lb_subnet_id]
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false # Default is false, left here for reference
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    kubernetes_network_config {
      services_cidr = var.k8s_service_cidr
      pods_cidr     = var.k8s_pods_cidr
    }
  }

}

resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = var.node_pool_name
  node_shape         = "VM.Standard.E3.Flex"
  ssh_public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr6/DNzYrV+FXzJItkGMhq4lwblVe4noOB6AVdSYmTkifxS2XKt94cWBGNg1PqTi/RNwlTxAWsdyUsOsfi6MyaWYdYOXp9q5yEAwg3eSrOT+qJ4QL0UwA32oZMI8+W3FrTPZ5jaV6vPvykcgk5K7eai/2SzMawiKsJfMjEDTdVsDbClQBNZXtFVimmbPwvK+4dwhlEymTQXzbd/PMMgIOqJlBeCFbug1rIkUgz0PQ6iWLJuVIwh/sZUW4MfXUIxBztuImh90LAtcRNO62Dn4HUx519VgR7lhjIotxdGPggwKeq6WfJ8TOCCBIkJLeyW06AGFsSJVrhrcK+2RiJG1RP ssh-key-2022-02-02"

  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.ADs.availability_domains

      content {
        availability_domain = placement_configs.value.name
        subnet_id           = var.k8s_nodes_subnet_id
      }
    }
    size = 1
  }

  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      ocpus         = 1
      memory_in_gbs = 16
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = var.image_id
    boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
  }

  initial_node_labels {
    key   = "name"
    value = var.node_pool_name
  }

}



