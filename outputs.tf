output "master_server_ip" {
  value = aws_eip.master_static_ip.public_ip
}

output "worker_server_ip" {
  value = aws_eip.worker_static_ip.*.public_ip
}
