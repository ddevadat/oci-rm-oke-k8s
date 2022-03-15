# Copyright (c) 2020, 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.36.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}

provider "oci" {
  alias        = "home_region"
  tenancy_ocid = var.tenancy_ocid
  region       = lookup(data.oci_identity_regions.home_region.regions[0], "name")

  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

provider "oci" {
  alias        = "current_region"
  tenancy_ocid = var.tenancy_ocid
  region       = var.region

  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

# provider "kubernetes" {
#   host                   = module.oke.cluster_endpoint
#   cluster_ca_certificate = module.oke.cluster_ca_certificate
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["ce", "cluster", "generate-token", "--cluster-id", module.oke.cluster_id, "--region", module.oke.cluster_region]
#     command     = "oci"
#   }
# }

