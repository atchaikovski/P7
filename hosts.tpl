[masters]
%{ for index,ip in list_master ~}
master ansible_host=${ip}
%{ endfor ~}

[workers]
%{ for index,ip in list_worker ~}
worker${index} ansible_host=${ip}
%{ endfor }
