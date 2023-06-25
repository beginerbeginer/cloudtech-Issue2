from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet, DirectConnect, VPCPeering, InternetGateway
from diagrams.onprem.network import Internet
from diagrams.onprem.client import Users
from diagrams.onprem.compute import Server

graph_attr = {
    "fontsize": "20"
}

with Diagram("VPC Architecture Issue3", show=True, graph_attr=graph_attr, outformat="png"):
    users_01 = Users("ユーザー")
    datacenter = Server("データセンター")
    direct_connect = DirectConnect("Direct Connect")

    with Cluster("AWS Cloud"):
        internet_gateway = InternetGateway("Internet Gateway")

        with Cluster("VPC for Production 1\n10.0.0.0/16"):
            vpc_prod_1 = VPC("VPC - Production 1")
            with Cluster("Subnets"):
                public_subnet_prod_1 = PublicSubnet("Public Subnet\n10.0.1.0/24")
                private_subnet_prod_1 = PrivateSubnet("Private Subnet\n10.0.2.0/24")

        with Cluster("VPC for Production 2\n10.1.0.0/16"):
            vpc_prod_2 = VPC("VPC - Production 2")
            with Cluster("Subnets"):
                public_subnet_prod_2 = PublicSubnet("Public Subnet\n10.1.1.0/24")
                private_subnet_prod_2 = PrivateSubnet("Private Subnet\n10.1.2.0/24")

        with Cluster("VPC for Data Integration\n10.2.0.0/16"):
            vpc_data_integration = VPC("VPC - Data Integration")
            with Cluster("Subnets"):
                public_subnet_data_integration = PublicSubnet("Public Subnet\n10.2.1.0/24")
                private_subnet_data_integration = PrivateSubnet("Private Subnet\n10.2.2.0/24")

        # Connect nodes within AWS Cloud
        vpc_peering_1 = VPCPeering("VPC Peering 1")
        vpc_peering_2 = VPCPeering("VPC Peering 2")
        vpc_peering_3 = VPCPeering("VPC Peering 3")

        vpc_prod_1 - Edge(color="brown", style="dashed") - vpc_peering_1 - Edge(color="brown", style="dashed") -  vpc_prod_2
        vpc_prod_1 - Edge(color="brown", style="dashed") - vpc_peering_2 - Edge(color="brown", style="dashed") -  vpc_data_integration
        vpc_prod_2 - Edge(color="brown", style="dashed") - vpc_peering_3 - Edge(color="brown", style="dashed") -  vpc_data_integration

    # Connect nodes outside of AWS Cloud
    users_01 - internet_gateway - public_subnet_prod_1
    users_01 - internet_gateway - public_subnet_prod_2
    datacenter - direct_connect - vpc_data_integration
