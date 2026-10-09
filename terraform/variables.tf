variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "wildlife-eks"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "node_count" {
  default = 2
}
