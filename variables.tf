variable aws_profile {
    type = string
    default = null
}

variable aws_region {
    type = string
    default = null
}

variable peoplevox_vpc_cidr {
  type        = string
  default = "10.0.0.0/16"
  description = "Main VPC to have all the resources."
}

variable peoplevox_public_subnet_cidr {
  type    = list(string)
  default = ["10.0.1.0/24"]
} 

variable peoplevox_private_subnet_cidr {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}


variable peoplevox_db_subnet_group_name {
  description = "The name of the RDS subnet group."
  type        = string
  default     = "ck-pvx-db-subnet-group"
}

variable peoplevox_db_allocated_storage {
  description = "The allocated storage for the RDS instance."
  type        = number
  default     = 20
}

variable peoplevox_db_instance_type {
  description = "The instance type for the RDS instance."
  type        = string
  default     = "db.t2.micro"
}

variable peoplevox_db_identifier {
  description = "The identifier for the RDS instance."
  type        = string
  default     = "ck-pvx-db"
}

#ariable peoplevox_db_username {
#  description = "The username for the RDS instance."
#  type        = string
  #default     = "dbuser"
#}

#variable peoplevox_db_password {
#  description = "The password for the RDS instance."
# type        = string
  # Avoid setting a default for sensitive data like passwords
#}
