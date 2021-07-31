# EC2 Security Group
resource "aws_security_group" "ec2-security-group" {
  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# EC2 Subnet Group
resource "aws_subnet" "ec2_subnet_group" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

# Key Pair Algorithm
resource "tls_private_key" "this" {
  algorithm = "RSA"
}


module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "malpanez"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4qQXyZofIlAoVtebiozx1rxzPA7UGJZKZqXrDt3as73m7w/qDPZiM5ysHlObsNQIxFrbpWYy18onfq3SRU+yZzEKwcHEYwDQO/LHNMt6y5mmHMi6l1ZAXgoucwJgbWebfB31hPv1lkhxjH+qfDaVAw6eGQ1ye3k/383cBo1R5DhCMGNb96CuC5IdqmNwEIxyr17W+ONt9GOFaCIqxdDJTSzECV8iF5F8sVHlLqFRdHudD2on4ZvX6li9RbJLfhgoLtDvnqeYAvIiT3S9Zak2hSFks6p/s9MUAlbdCQ7QEEWVPPy3XkAw8MU+qoeA4/bGXCHDGSDTmg+dTTXf1G/bobeOVdDka13YmII/bSs/vNHoIzv76GHTWcxogTjU2FuH0Y+m+MwsESfbt7hZHk1HvKlpnygqo40TJWVgkH1ShcKFeF2hi1eYrXGZTOVSTJWW+CfrJGkjNBw/kMC/8KCm1BLpoKys9qabI1SgZGSVImzcq3UmKpEa3OUrgky7IBvIPLEoo40TbLoKnxc5yj/8ePKOG3fg9jCddTWh2kZjeG7cODg4baWdGySKmY0x+XWmytakR+8EqimBZQRfmWM9njjHovAEwoMOxkjuf+9sCB3Jb4UR2JFWjBKKO7iLoqUOEMdFVnuvuerSJqGeyZDkImr3EZzxEgbOCbstYBQoYAw== AWS"
}


# EC2 Instance with User Data
resource "aws_instance" "ec2-instance" {
  ami                    = "ami-0dc2d3e4c0f9ebd18"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.ec2_subnet_group.id
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
  user_data              = file("user-data.sh")
  key_name               = module.key_pair.key_pair_key_name
  # associate_public_ip_address = true

  tags = {
    Name = "Application Server"
  }

}

# Elastic IP
resource "aws_eip" "my-eip" {
  instance = aws_instance.ec2-instance.id
  vpc      = true
}

# Route Table
resource "aws_route_table" "my-route-table" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

  tags = {
    Name = "Public RT"
  }

}

# Route Table Association
resource "aws_route_table_association" "my-route-table-association" {
  subnet_id      = aws_subnet.ec2_subnet_group.id
  route_table_id = aws_route_table.my-route-table.id
}