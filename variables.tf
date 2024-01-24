variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the cluster"
  type        = string
  default     = "1.26"
}

variable "image_tag" {
  description = "Image tag"
  type        = string
  default     = "v1.26.1"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

variable "cidr" {
  description = "CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

// Should this be retrieved automatically based on region and CIDR?
variable "subnets" {
  description = "List of subnets"
  type        = list(map(string))
  default     = [
    { cidr_block = "10.0.1.0/24", az = "us-east-1a" },
    { cidr_block = "10.0.2.0/24", az = "us-east-1b" },
    { cidr_block = "10.0.3.0/24", az = "us-east-1c" }
  ]
}

variable "public_access_cidrs" {
  description = "List of CIDRs for public access"
  type        = list(string)
  default     = []
}

variable "instance_types" {
  description = "List of instance types"
  type        = list(string)
  default     = ["m5.large"]
}
