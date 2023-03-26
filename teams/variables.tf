variable "name" {
  type = string
  description = "The name of the team"
}

variable "number" {
  type = number
  description = "The number of the team"
}

variable "gateway" {
  type = any
  description = "The gateway resource"
}