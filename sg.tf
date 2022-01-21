# ---------------------- allowed ports --------------------------------------
locals {
  _start = [22, 443, 2379, 6443, 10248, 10257, 10259, 30000] # from_ports
  _end   = [22, 443, 2380, 6443, 10250, 10257, 10259, 32767] # to_ports
}

# ----------- Security group resources ---------------------------------------

resource "aws_security_group" "sg" {
  name = "k8s Security Group"

  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local._start
    content {
      from_port   = ingress.value
      to_port     = element(local._end, index(local._start,ingress.value))
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "k8s SecurityGroup" 
  }

}
