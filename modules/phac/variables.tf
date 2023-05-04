variable "client_ip_v4" {
  type = any
  description = "The client ip v4 that will connect to the database"
}

variable "db_name_prefix" {
  type = string
  description = "The name of the PostgreSQL Highly Available Cluster (PHAC)"
}

variable "key_pair" {
  type = string
}

# variable "DBUSER" {
  # type = string
  # description = "The username for the database user"
  # sensitive = true
# }
# 
# variable "DBPASS" {
  # type = string
  # description = "The password for the database user"
  # sensitive = true
# }