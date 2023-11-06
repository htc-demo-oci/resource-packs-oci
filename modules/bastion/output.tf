output "bastion_ocid" {
  description = "OCID of Bastion service instance"
  value       = oci_bastion_bastion.bastion.id
}