locals {
  cluster_k8s_latest_version = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
  #   node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.oke.kubernetes_versions))[0]
}
