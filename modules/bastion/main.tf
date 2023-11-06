resource "oci_bastion_bastion" "bastion" {
  bastion_type                 = "standard"
  compartment_id               = var.bastion_compartment_ocid
  target_subnet_id             = var.bastion_target_subnet_ocid
  name                         = "${var.prefix}${var.bastion_name}"
  max_session_ttl_in_seconds   = var.bastion_max_session_ttl_in_seconds
  client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
}