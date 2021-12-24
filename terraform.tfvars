region                     = "us-east-1"
instance_type              = "t2.medium"
enable_detailed_monitoring = true

private_key  =  "~/.ssh/aws_adhoc.pem"
public_key   =  "~/.ssh/aws_adhoc.pub"

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Small k8s cluster"
  Purpose     = "P7"
}

master_host_name = "master"
worker_host_name = "worker"
worker_count = 2
master_count = 1