
# MySQL DB System


module "mysql_db_system" {
  source                                  = "git::https://github.com/mzachh/resource-packs-oci.git//modules/mysql/basic?ref=dev"
  prefix                                  = var.prefix
  region                                  = var.region
  bastion_ocid                            = var.bastion_ocid
  mysql_schema_name                       = var.mysql_schema_name
  mysql_shape_name                        = var.mysql_shape_name
  mysql_db_system_data_storage_size_in_gb = var.mysql_db_system_data_storage_size_in_gb
  mysql_instance_compartment_ocid         = var.mysql_instance_compartment_ocid
  mysql_instance_subnet_ocid              = var.mysql_instance_subnet_ocid
  mysql_db_system_admin_username          = var.mysql_db_system_admin_username
  mysql_db_system_admin_password          = var.mysql_db_system_admin_password
  mysql_db_system_availability_domain     = var.mysql_db_system_availability_domain
}

resource "oci_mysql_heat_wave_cluster" "heatwave" {
  db_system_id = module.mysql_db_system.mysql_db_system_id
  cluster_size = var.mysql_heatwave_cluster_size
  shape_name   = var.mysql_heatwave_shape
}