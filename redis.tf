resource "aws_elasticache_cluster" "redis-cache" {
  cluster_id           = "redis-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis-security-group.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis-subnet-group.name
}

# Redis Subnet Group
resource "aws_subnet" "redis_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.4.0/24"
}

resource "aws_elasticache_subnet_group" "redis-subnet-group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]
}

# Redis Security Group
resource "aws_security_group" "redis-security-group" {
  name   = "redis-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-security-group.id]
  }
}

# Get my IP address by using the http data source, which runs a get request
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}