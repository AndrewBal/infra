provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "sumo-multi-region-tf-state"
    key    = "tf-state"
    region = "us-west-2"
  }
}



#########################################
# Redis
#########################################

module "redis-shared" {
    source = "redis"
    redis_name = "shared"
    redis_node_size = "cache.m3.large"
    redis_num_nodes = 3
    subnets = "${var.subnets}"
    nodes_security_groups = "${var.nodes_security_groups}"
}

#########################################
# MySQL
#########################################
module "mysql-dev" {
    source = "rds"
    mysql_env     = "dev"
    # DBName must begin with a letter and contain only alphanumeric characters
    mysql_db_name = "sumo_dev"
    mysql_username = "root"
    mysql_password = "${var.mysql_dev_password}"
    mysql_identifier = "sumo-dev"
    mysql_instance_class = "db.t2.small"
    mysql_backup_retention_days = 0
    mysql_security_group_name = "sumo_rds_sg_dev"
    mysql_storage_gb = 250
    mysql_storage_type = "gp2"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
}

/*
module "mysql-stage" {
    source = "rds"
    mysql_env     = "stage"
    # DBName must begin with a letter and contain only alphanumeric characters
    mysql_db_name = "sumo_stage"
    mysql_username = "root"
    mysql_password = "${var.mysql_stage_password}"
    mysql_identifier = "sumo-stage"
    mysql_instance_class = "db.t2.small"
    mysql_backup_retention_days = 0
    mysql_security_group_name = "sumo_rds_sg_stage"
    mysql_storage_gb = 250
    mysql_storage_type = "gp2"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
}
*/

module "mysql-prod" {
    source = "rds-multi-az"
    # DBName must begin with a letter and contain only alphanumeric characters
    mysql_env     = "prod"
    mysql_db_name = "sumo_prod"
    mysql_username = "root"
    mysql_password = "${var.mysql_prod_password}"
    mysql_identifier = "sumo"
    mysql_instance_class = "db.m4.2xlarge"
    mysql_backup_retention_days = 7
    mysql_security_group_name = "sumo_rds_sg_prod"
    mysql_storage_gb = 250
    mysql_storage_type = "gp2"
    subnets = "${var.subnets}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
}



