output "security_groups" {
  value = [
    "${aws_security_group.default.id}",
    "${aws_security_group.public-web.id}",
    "${aws_security_group.public-ssh.id}",
  ]
}

output "subnets" {
  value = [
    "${aws_subnet.public-a.id}",
    "${aws_subnet.public-b.id}",
    "${aws_subnet.public-c.id}",
  ]
}
