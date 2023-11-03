output "host" {
    description = "The hostname the MySQL instance is available on"
    value       = oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.hostname
}

output "ip_address" {
    description = "The IP address the MySQL instance is available on"
    value       = oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.ip_address
}

output "name" {
    description = "The name of the database that the workload should connect to"
    value = "todo"
}

output "port" {
    description = "The port on the host that the MySQL instance is available on"
    value       = oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.port
}