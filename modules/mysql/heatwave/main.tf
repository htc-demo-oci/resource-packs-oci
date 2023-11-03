resource "oci_mysql_mysql_db_system" "mysql_db_system" {
  admin_password      = var.mysql_db_system_admin_password
  admin_username      = var.mysql_db_system_admin_username
  availability_domain = var.mysql_db_system_availability_domain
  backup_policy {
    is_enabled = var.mysql_db_system_backup_policy_is_enabled
  }
  compartment_id          = var.mysql_instance_compartment_ocid
  crash_recovery          = "ENABLED"
  data_storage_size_in_gb = var.mysql_db_system_data_storage_size_in_gb
  deletion_policy {
    automatic_backup_retention = "DELETE"
    final_backup               = "SKIP_FINAL_BACKUP"
    is_delete_protected        = "false"
  }
  display_name  = "${var.prefix}${var.mysql_db_system_display_name}"
  freeform_tags = var.mysql_db_system_freeform_tags
  port          = var.mysql_db_system_port
  port_x        = var.mysql_db_system_port_x
  shape_name    = var.mysql_shape_name
  subnet_id     = var.mysql_instance_subnet_ocid
}