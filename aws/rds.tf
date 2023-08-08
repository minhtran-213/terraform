resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  username             = "ass_admin"
  password             = "password"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.mydb_subnet_group.name
  multi_az             = false
  deletion_protection  = false
  identifier           = "mydb-instance"
}

resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb_subnet_group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "mydb_subnet_group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "allow_rds"
  description = "Allow RDS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to your needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}
