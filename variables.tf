variable "aws_region" {
  default = "ap-southeast-2"
}

variable "key_name" {
  default = "Moodle_keypair"
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  description = "Ubuntu 24.04 LTS"
  default     = "ami-0279a86684f669718"
}

variable "disk_size" {
  description = "Root EBS volume size in GB"
  default     = 12
}
