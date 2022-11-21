
output "cluster_ca_certificate" {
  value = base64decode(yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["clusters"][0]["cluster"]["certificate-authority-data"])
}

output "cluster_endpoint" {
  value = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["clusters"][0]["cluster"]["server"]
}

output "cluster_id" {
  value = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["users"][0]["user"]["exec"]["args"][4]
}

output "cluster_region" {
  value = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["users"][0]["user"]["exec"]["args"][6]
}


output "oke_cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}

output "oke_nodepool_id" {
  value = oci_containerengine_node_pool.oke_node_pool.id
}