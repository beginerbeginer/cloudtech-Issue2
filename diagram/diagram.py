from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet, InternetGateway
from diagrams.onprem.network import Internet
from diagrams.onprem.client import Users


graph_attr = {
    "fontsize": "20"
}

with Diagram("Architecture", show=True, graph_attr=graph_attr, outformat="png"):
    with Cluster("system"):
        internet_01 = Internet("Internet")
        users_01 = Users("ユーザー")
        with Cluster("AWS Cloud"):
            with Cluster("Region - ap-northeast-1"):
                with Cluster("VPC"):
                    igw_01 = InternetGateway("InternetGateway")
                    with Cluster("Availability Zone - ap-northeast-1a"):
                        with Cluster("Public Subnets"):
                            public_subnet_a = PublicSubnet("Public Subnet A\n10.0.0.0/24")
                        with Cluster("Private Subnets"):
                            private_subnet1_a = PrivateSubnet("Private Subnet 1 A\n10.0.1.0/24")
                            private_subnet2_a = PrivateSubnet("Private Subnet 2 A\n10.0.2.0/24")


                    with Cluster("Availability Zone - ap-northeast-1c"):
                        with Cluster("Public Subnets"):
                            public_subnet_c = PublicSubnet("Public Subnet C\n10.0.3.0/24")
                        with Cluster("Private Subnets"):
                            private_subnet1_c = PrivateSubnet("Private Subnet 1 C\n10.0.4.0/24")
                            private_subnet2_c = PrivateSubnet("Private Subnet 2 C\n10.0.5.0/24")

                    # 構成図の線を引く
                    users_01 - internet_01 - igw_01 - public_subnet_a
                    users_01 - internet_01 - igw_01 - public_subnet_c
                    public_subnet_a - Edge(color="brown", style="dashed") - private_subnet1_a
                    private_subnet1_a - Edge(style="dotted") - private_subnet2_a
                    public_subnet_c - Edge(color="brown", style="dashed") - private_subnet1_c
                    private_subnet1_c - Edge(style="dotted") - private_subnet2_c

