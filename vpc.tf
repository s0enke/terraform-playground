resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags {
        Name = "public"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main"
    }
}
resource "aws_route_table" "rtb_public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "public"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route53_zone" "primary" {
   name = "testing.ruempler.eu"
}

