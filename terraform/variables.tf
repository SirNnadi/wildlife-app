variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "cluster_name" {
  default = "wildlife-eks"
}

variable "kubernetes_version" {
  default = "1.31"
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

variable "min_node_count" {
  default = 1
}

variable "max_node_count" {
  default = 3
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
