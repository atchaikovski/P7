# ------------------- EC2 resources ---------------------------------

resource "aws_instance" "master" {
  ami                         = "ami-0e472ba40eb589f49" # ubuntu
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = "aws_adhoc"
  count                       = var.master_count
  associate_public_ip_address = true
  
  tags = { 
    Name = "Master Server"
  }

}

resource "aws_instance" "worker" {
  ami                         = "ami-0e472ba40eb589f49" # ubuntu
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = "aws_adhoc"
  count                       = var.worker_count
  associate_public_ip_address = true

  tags = {
    Name = "Worker Server # ${count.index}"
 }
}

# --------------- write inventory file ---------------------

 resource "local_file" "inventory" {
	  content = templatefile("${path.module}/hosts.tpl", {
		list_master = slice(aws_instance.master.*.public_ip, 0, var.master_count),
		list_worker = slice(aws_instance.worker.*.public_ip, 0, var.worker_count)
	  })
	  filename = "inventory"
	}

# --------- launch Ansible to deploy k8s on these resources ---------

resource "null_resource" "null1" {
  depends_on = [
     local_file.inventory
  ]

  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "local-exec" {
     command = "ansible-playbook -i ./inventory --private-key ${var.private_key} -e 'pub_key=${var.public_key}' playbook.yml"
  }

}

# --------------- get static IP addresses ------------------

resource "aws_eip" "master_static_ip" {
  instance = aws_instance.master[0].id
  vpc = true
  tags = { Name = "master Server IP" }
}

resource "aws_eip" "worker_static_ip" {
  count = var.worker_count
  instance = "${element(aws_instance.worker.*.id,count.index)}"
  vpc = true
  tags = { Name = "worker${count.index} Server IP" }
}