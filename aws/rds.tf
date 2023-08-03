module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class    = "db.t2.micro"

  allocated_storage = 20

  db_name = "prod_rds"
  username = "ass_admin"
  password = "testpassword"
  port     = "5432"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_db_subnet_group = false

  tags = {
    Environment = "test"
    Name        = "demodb"
  }
}