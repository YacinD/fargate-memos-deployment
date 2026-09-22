resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "${var.project_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
    description     = "Postgres from ECS only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-db"
  engine                  = "postgres"
  engine_version           = "16"
  instance_class           = var.instance_class
  allocated_storage        = 20
  storage_encrypted        = true
  db_name                  = var.db_name
  username                 = var.db_username
  password                 = random_password.db.result
  db_subnet_group_name     = aws_db_subnet_group.this.name
  vpc_security_group_ids   = [aws_security_group.rds.id]
  publicly_accessible      = false
  multi_az                 = false
  skip_final_snapshot      = true
  deletion_protection      = false

  tags = {
    Name = "${var.project_name}-db"
  }
}

resource "aws_secretsmanager_secret" "db_dsn" {
  name = "${var.project_name}-db-dsn"
}

resource "aws_secretsmanager_secret_version" "db_dsn" {
  secret_id     = aws_secretsmanager_secret.db_dsn.id
  secret_string = "postgres://${var.db_username}:${random_password.db.result}@${aws_db_instance.this.endpoint}/${var.db_name}?sslmode=disable"
}