# Add local provider configuration: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File
# provider "oci" {
#   region          = var.region
#   tenancy_ocid    = var.tenancy_ocid
#   ...
# }

provider "oci" {
  alias  = "home"
  region = var.region
}