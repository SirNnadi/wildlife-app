region           = "us-east-1"
environment      = "prod"
cluster_name     = "wildlife-eks-prod"
kubernetes_version = "1.31"

vpc_cidr         = "10.2.0.0/16"
public_subnets   = ["10.2.0.0/24", "10.2.1.0/24"]

instance_type    = "t3.medium"
node_count       = 3
min_node_count   = 2
max_node_count   = 6
