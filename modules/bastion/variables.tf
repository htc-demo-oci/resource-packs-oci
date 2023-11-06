variable "prefix" {
  default = ""
}

variable "bastion_compartment_ocid" {
  description = "(Required) (Updatable) The unique identifier (OCID) of the compartment where the bastion is located."
}

variable "bastion_client_cidr_block_allow_list" {
  description = "(Required) A list of address ranges in CIDR notation that you want to allow to connect to sessions hosted by this bastion."
}

variable "bastion_target_subnet_ocid" {
  description = "(Required) The unique identifier (OCID) of the subnet that the bastion connects to"
}

variable "bastion_name" {
  description = "(Optional) The name of the bastion"
  default     = "Bastion"
}

variable "bastion_max_session_ttl_in_seconds" {
  description = "(Optional) (Updatable) The maximum amount of time that any session on the bastion can remain active."
  default     = "10800"
}