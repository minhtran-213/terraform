resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow inbound traffic for database"
  vpc_id      = module.vpc.vpc_id  # Ensure this is the same VPC as your RDS instance

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}