variable "cidr" {
    default = "10.0.0.0/16"
}
variable "vpcname" {
    default = "Demo_VPC"
}
variable "publiccidrs" {
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}
variable "azs" {
    default = ["us-east-1a","us-east-1b","us-east-1c"]
}
variable "privatecidrs" {
    default = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}
variable "ami" {
    default = "ami-0e472ba40eb589f49"
}