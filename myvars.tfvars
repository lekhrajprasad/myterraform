availability_zone="us-east-1a"
ec2_count="2"
ami="ami-0d5eff06f840b45e9"
instance_type="t2.micro"
servername="ec2-terraform"
key_name="terraform_key"
region="us-east-1"

vpc_cdr="192.170.0.0/16"
vpc_name="terraform_vpc"
vpc_location="Bangalore"
igw_name="terraform_igw"

rout_cdr="0.0.0.0/0" //open to world
rout_name="terraform_rout"

subnet_cidr="192.170.5.0/24"
subnet_name="terraform_subnet"
