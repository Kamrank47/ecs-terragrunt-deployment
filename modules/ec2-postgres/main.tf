resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "aws_iam_role" "ec2_postgres_role" {
  name = "${var.environment}-ec2-postgres-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_postgres_ssm" {
  role       = aws_iam_role.ec2_postgres_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_postgres_profile" {
  name = "${var.environment}-ec2-postgres-profile"
  role = aws_iam_role.ec2_postgres_role.name
}

resource "aws_instance" "postgres" {
  ami                    = var.postgres_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.ec2.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_postgres_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    delete_on_termination = false
    encrypted             = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update -y
              apt-get upgrade -y

              # Install PostgreSQL
              apt-get install -y postgresql postgresql-contrib

              # Configure PostgreSQL to accept connections from the ECS service
              echo "listen_addresses = '*'" >> /etc/postgresql/*/main/postgresql.conf
              echo "host all all ${var.ecs_cidr} md5" >> /etc/postgresql/*/main/pg_hba.conf

              # Restart PostgreSQL
              systemctl restart postgresql
              EOF

  tags = {
    Name = "${var.environment}-postgres"
  }
}

output "ec2_private_key_pem" {
  value     = tls_private_key.ec2.private_key_pem
  sensitive = true
}