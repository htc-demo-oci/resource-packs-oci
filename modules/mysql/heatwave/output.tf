output "host" {
  description = "The hostname the MySQL instance is available on"
  value       = module.mysql_db_system.host
}

output "ip_address" {
  description = "The IP address the MySQL instance is available on"
  value       = module.mysql_db_system.ip_address
}

output "name" {
  description = "The name of the database that the workload should connect to"
  value       = module.mysql_db_system.name
}

output "port" {
  description = "The port on the host that the MySQL instance is available on"
  value       = module.mysql_db_system.port
}