
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

locals {

  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr6/DNzYrV+FXzJItkGMhq4lwblVe4noOB6AVdSYmTkifxS2XKt94cWBGNg1PqTi/RNwlTxAWsdyUsOsfi6MyaWYdYOXp9q5yEAwg3eSrOT+qJ4QL0UwA32oZMI8+W3FrTPZ5jaV6vPvykcgk5K7eai/2SzMawiKsJfMjEDTdVsDbClQBNZXtFVimmbPwvK+4dwhlEymTQXzbd/PMMgIOqJlBeCFbug1rIkUgz0PQ6iWLJuVIwh/sZUW4MfXUIxBztuImh90LAtcRNO62Dn4HUx519VgR7lhjIotxdGPggwKeq6WfJ8TOCCBIkJLeyW06AGFsSJVrhrcK+2RiJG1RP ssh-key-2022-02-02"

}
