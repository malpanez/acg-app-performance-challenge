# RDS Security Group
resource "aws_security_group" "rds-security-group" {
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnets
resource "aws_subnet" "rds_subnet_group_1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "RDS Subnet-1"
  }

}

resource "aws_subnet" "rds_subnet_group_2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "RDS Subnet-2"
  }

}

# RDS Subnets Group
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds_subnet"
  subnet_ids = [aws_subnet.rds_subnet_group_1.id, aws_subnet.rds_subnet_group_2.id]
}

# RDS Instance
resource "aws_db_instance" "acg-db" {
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.7"
  instance_class         = "db.t2.micro"
  name                   = "postgres"
  username               = "postgres"
  password               = "postgres"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
}