output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}

output "worknode" {
  value = "${aws_instance.worknode.private_ip}"
}
