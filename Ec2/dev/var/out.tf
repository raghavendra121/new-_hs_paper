output "subnet1" {
    value = aws_subnet.subnet1.id
}
output "sg3" {
    value = aws_security_group.sg3.id
}
output "tls_private_key" {
    value = aws_key_pair.generated_key.id
}