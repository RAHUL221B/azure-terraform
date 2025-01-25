variable "web_linuxvm_instance_count" {
  description = "linux instance count"
  type = number
  default = 1
}

variable "lb_inbound_nat_ports" {
  description = "Web LB Inbound NAT Ports List"
  type = list(string)
  default = ["1022", "2022", "3022", "4022", "5022"]
}