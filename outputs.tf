output "key_pair" {
  description = "Key Pair Material"
  value       = module.key_pair.key_pair_fingerprint
}

output "ec2-eip" {
  description = "Elastic IP EC2 Instance"
  value       = aws_eip.my-eip.*.public_ip
}

output "rds_endpoint" {
  description = "RDS Instance Endpoint"
  value       = aws_db_instance.acg-db.endpoint
}

output "rds_port" {
  description = "RDS Instance Port"
  value       = aws_db_instance.acg-db.port
}