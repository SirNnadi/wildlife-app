region           = "us-east-1"
environment      = "dev"
cluster_name     = "wildlife-eks-dev"
kubernetes_version = "1.31"

vpc_cidr         = "10.0.0.0/16"
public_subnets   = ["10.0.0.0/24", "10.0.1.0/24"]

instance_type    = "t3.medium"
node_count       = 2
min_node_count   = 1
max_node_count   = 3
