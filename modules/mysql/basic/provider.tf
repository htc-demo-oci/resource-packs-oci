# Add local provider configuration: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File
# provider "oci" {
#   region          = var.region
#   tenancy_ocid    = var.tenancy_ocid
#   ...
# }
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.18.0"
    }
  }
}

provider "oci" {
   alias = "home"
   tenancy_ocid = "${var.tenancy_ocid}"
   user_ocid = "${var.user_ocid}"
   fingerprint = "${var.fingerprint}"
   region = "${var.region}"
   private_key = "${var.private_key}"
}