resource "aws_vpc" "myvpc" {
  cidr_block       = "${var.cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "${var.vpcname}"
  }
}

resource "aws_subnet" "publicsubnets" {
    count = "${length(var.publiccidrs)}"
    vpc_id     = "${aws_vpc.myvpc.id}"
    cidr_block = "${element(var.publiccidrs,count.index)}"
    availability_zone = "${element(var.azs,count.index)}"
    tags = {
         Name = "Publicsubnet -${count.index+1}"
         }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.myvpc.id}"
    tags = {
        Name = "Igw_${var.vpcname}"
        }
}


resource "aws_route_table" "publicrt" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
        }
        tags = {
            Name = "Public_RouteTable__${var.vpcname}"
            }
}

resource "aws_route_table_association" "publicrta" {
    count = "${length(var.publiccidrs)}"
    subnet_id = "${element(aws_subnet.publicsubnets.*.id,count.index)}"
    route_table_id = "${aws_route_table.publicrt.id}"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip1.id}"
  subnet_id = "${aws_subnet.publicsubnets.1.id}"

  tags = {
    Name = "NAT_${var.vpcname}"
  }
}
resource "aws_subnet" "privatesubnets" {
    count = "${length(var.privatecidrs)}"
    vpc_id     = "${aws_vpc.myvpc.id}"
    cidr_block = "${element(var.privatecidrs,count.index)}"
    availability_zone = "${element(var.azs,count.index)}"
    tags = {
         Name = "Privatesubnet -${count.index+1}"
         }
}
resource "aws_route_table" "privatert" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
        }
        tags = {
            Name = "Private_RouteTable__${var.vpcname}"
            }
}
resource "aws_route_table_association" "privaterta" {
    count = "${length(var.privatecidrs)}"
    subnet_id = "${element(aws_subnet.privatesubnets.*.id,count.index)}"
    route_table_id = "${aws_route_table.privatert.id}"
}