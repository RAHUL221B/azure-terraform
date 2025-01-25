# Web Linux VM Instance Count

variable "web_linuxvm_instance_count" {
  description = "linux instance count"
  type = map(string)
  default = {
    "vm1" : "1022",
    "vm2" : "2022"
  }
}

