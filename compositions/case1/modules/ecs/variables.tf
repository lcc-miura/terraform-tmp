# ------------------------------
# Variables
# ------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_1a__id" {
  type = string
}

variable "public_subnet_1c__id" {
  type = string
}

variable "private_subnet_1a_mgr__id" {
  type = string
}

variable "private_subnet_1c_mgr__id" {
  type = string
}