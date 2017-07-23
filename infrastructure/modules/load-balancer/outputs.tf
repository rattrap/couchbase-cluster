output "name" {
  value = "${aws_elb.elb.name}"
}

output "dns-name" {
  value = "${aws_elb.elb.dns_name}"
}
