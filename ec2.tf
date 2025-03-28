# Security Group allowing SSH and HTTP
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-public-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.249.107.86/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["49.249.107.86/32"]
  }

  egress {
    description = "Allow SSH from admin IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["49.249.107.86/32"]
  }

  tags = {
    Name = "ec2-public-sg"
  }
}

# EC2 instance in public subnet
resource "aws_instance" "public_ec2" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  #  key_name               = aws_key_pair.my_key.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required" # Enforce IMDSv2
    http_endpoint = "enabled"  # IMDS endpoint must be enabled
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello from Terraform EC2 in Public Subnet" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Public-EC2"
  }
}
