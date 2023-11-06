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

# Bastion Session
resource "tls_private_key" "bastion_public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_bastion_session" "mysql_session" {
  bastion_id = var.bastion_ocid
  key_details {
    public_key_content = tls_private_key.bastion_public_private_key_pair.public_key_openssh
  }
  target_resource_details {
    session_type                       = "PORT_FORWARDING"
    target_resource_port               = oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.port
    target_resource_private_ip_address = oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.ip_address
  }
  display_name           = "terraform_MySQL"
  key_type               = "PUB"
  session_ttl_in_seconds = 10800
}

resource "local_sensitive_file" "sessionkey" {
  content         = tls_private_key.bastion_public_private_key_pair.private_key_openssh
  filename        = ".bastion-session-key"
  file_permission = "0400"
}

resource "local_file" "bastion_helpers" {
  content         = <<-EOT
    #!/bin/bash
    set -e
    LOCALPORT=`shuf -i 10000-60000 -n 1`

    function cleanup {
        ssh -S /tmp/.ssh-oci-bastion.$$ -O exit ${oci_bastion_session.mysql_session.id}@host.bastion.${var.region}.oci.oraclecloud.com
    }

    function run_with_retry {
      COMMAND=$1
      max_retries=3
      delay=10
      count=0

      while [ $count -lt $max_retries ]; do
        set +e
        $COMMAND
        exit_status=$?
        set -e
        if [ $exit_status -eq 0 ]; then
          break
        else
          count=$((count+1))
          sleep $delay
        fi
      done

      if [ $count -eq $max_retries ]; then
        echo "All retries failed"
        exit $exit_status
      fi
    }

    function create_bastion_forward {
        REMOTE_IP=$1
        REMOTE_PORT=$2

        COMMAND="ssh -f -o StrictHostKeyChecking=no -o HostKeyAlgorithms=ssh-ed25519 -i ${local_sensitive_file.sessionkey.filename} -S /tmp/.ssh-oci-bastion.$$ -M -N -L $LOCALPORT:$REMOTE_IP:$REMOTE_PORT -p 22 ${oci_bastion_session.mysql_session.id}@host.bastion.${var.region}.oci.oraclecloud.com"
        run_with_retry "$COMMAND"

        ssh -S /tmp/.ssh-oci-bastion.$$ -O check ${oci_bastion_session.mysql_session.id}@host.bastion.${var.region}.oci.oraclecloud.com
    }
    EOT
  filename        = "bastion-helpers.sh"
  file_permission = "0755"
}

resource "local_file" "create-mysql-database" {
  content         = <<-EOT
    #!/bin/bash
    
    source ${local_file.bastion_helpers.filename}

    create_bastion_forward ${oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.ip_address} ${oci_mysql_mysql_db_system.mysql_db_system.endpoints.0.port}

    mysql -u $MYSQL_USERNAME -h 127.0.0.1 -P $LOCALPORT -e 'CREATE SCHEMA IF NOT EXISTS ${var.mysql_schema_name}; SHOW SCHEMAS;'

    trap cleanup EXIT
    EOT
  filename        = "create-mysql-database.sh"
  file_permission = "0755"
}

resource "null_resource" "create_mysql_database" {
  provisioner "local-exec" {
    command = "./${local_file.create-mysql-database.filename}"
    environment = {
      MYSQL_USERNAME = var.mysql_db_system_admin_username
      MYSQL_PWD      = var.mysql_db_system_admin_password
    }
  }

  triggers = {
    mysql_db_system_id = oci_mysql_mysql_db_system.mysql_db_system.id
  }
}