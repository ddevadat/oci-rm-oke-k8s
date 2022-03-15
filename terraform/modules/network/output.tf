output "vcn_id" {
  value = oci_core_virtual_network.oke_vcn.id
}


output "k8s_endpoint_subnet_id" {
  value = oci_core_subnet.oke_k8s_endpoint_subnet.id
}


output "k8s_nodes_subnet_id" {
  value = oci_core_subnet.oke_nodes_subnet.id
}

output "k8s_lb_subnet_id" {
  value = oci_core_subnet.oke_lb_subnet.id
}
