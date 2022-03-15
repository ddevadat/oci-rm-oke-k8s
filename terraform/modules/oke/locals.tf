# locals {
#   cluster_k8s_latest_version   = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
#   node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.oke.kubernetes_versions))[0]
# }

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.node_pool_shape)
}


locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex"
  ]
}
