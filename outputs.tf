output "my_vpc_igw_rout_subnet_routtableassociation_id_created" {
        value = [aws_instance.myec2[*].id, aws_vpc.myvpc.id, aws_internet_gateway.myigw.id, aws_route_table.myrouttable.id, aws_subnet.mysubnet, aws_route_table_association.routassociation.id  ]
#value = [aws_vpc.myvpc.id, aws_internet_gateway.myigw.id, aws_route_table.myrouttable.id, aws_subnet.mysubnet, aws_route_table_association.routassociation.id  ]
}

