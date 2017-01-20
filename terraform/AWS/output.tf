output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}

output "worknode0" {
  value = "${element(aws_instance.worknode.*.private_ip, 0)}"
}

output "worknode1" {
  value = "${element(aws_instance.worknode.*.private_ip, 1)}"
}

output "worknode2" {
  value = "${element(aws_instance.worknode.*.private_ip, 2)}"
}

output "worknode3" {
  value = "${element(aws_instance.worknode.*.private_ip, 3)}"
}

output "worknode4" {
  value = "${element(aws_instance.worknode.*.private_ip, 4)}"
}
