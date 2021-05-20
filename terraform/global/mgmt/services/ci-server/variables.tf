variable "PATH_TO_PRIVATE_KEY" {
  default = "my-test-key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my-test-key.pub"
}

variable "environment_name" {
  default = "ci-server"
}

variable "cidr" {
  default = "32"
}

#Actual IP fetched from shell environment variables and ingress to CI-server restricted to this IP
variable "myip" {
}