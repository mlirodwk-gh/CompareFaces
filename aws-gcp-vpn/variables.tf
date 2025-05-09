variable "gcp_project_name" {
  description = "Name applied to this instance"
  type        = string
  default     = "mlirodwk-project"
}

variable "name" {
  description = "Name applied to this instance"
  type        = string
  default     = "vpn-gcp-aws"
}

variable "customer" {
  description = "Customer applied to this instance"
  type        = string
  default     = "mlirodwk"
}

variable "environment" {
  description = "Environment applied to this instance"
  type        = string
  default     = "develop"
}

variable "tags" {
  description = "Tags applied to this instance"
  type        = map(string)
  default = {
    "ManagedBy" = "terraform"
  }
}

# bellow are specific modules variables
variable "gcp_asn" {
  description = "Google Cloud side ASN"
  type        = number
  default = 64514
}

variable "gcp_cidr" {
  description = "CIDR group for GCP network"
  type        = string
  default = "10.1.0.0/16"
}

variable "gcp_network" {
  description = "Network name for GCP"
  type        = string
  default = "vpc-vpn-gcp-to-aws"
}

variable "gcp_region" {
  description = "Region for GCP"
  type        = string
  default = "us-east1"
}

variable "aws_region" {
  description = "Region for AWS"
  type        = string
  default = "us-east-1"
}

variable "aws_vpc" {
  description = "VPC ID for AWS"
  type        = string
  default = "vpc-0c4f1ca95cc90fccf"
}

variable "aws_route_tables_ids" {
  description = "Routing table ID for AWS"
  type        = list(string)
  default = [ "rtb-06bd1953201e38053" ]
}

variable "aws_existing_vpn_gateway_id" {
  description = "Optionally use an existeing VPN Gateway"
  type        = string
  default     = ""
}

locals {
  vpn_gateway_count = var.aws_existing_vpn_gateway_id != "" ? 0 : 1
  vpn_gateway_id    = var.aws_existing_vpn_gateway_id != "" ? var.aws_existing_vpn_gateway_id : aws_vpn_gateway.this[0].id
}