from diagrams import Cluster, Diagram
from diagrams.aws.network import InternetGateway, ElasticLoadBalancing
from diagrams.aws.compute import EC2, EC2AutoScaling
from diagrams.aws.database import RDS
from diagrams.onprem.client import Users
from diagrams.aws.network import PublicSubnet, PrivateSubnet

with Diagram("AWS Architecture", show=True):

    users_01 = Users("ユーザー")
    with Cluster("AWS Cloud"):

        internet_gateway = InternetGateway("internet gateway")
        elb = ElasticLoadBalancing("ELB")

        with Cluster("AZ1"):
            autoscaling1 = EC2AutoScaling("autoscaling1")
            with Cluster("Public Subnet"):
                public_subnet1 = PublicSubnet("public subnet 1")

            with Cluster("Private Subnet"):
                private_subnet1 = PrivateSubnet("private subnet 1")
                ec2_1 = EC2("EC2 instance1")
            rds1 = RDS("RDS (Primary)")
        with Cluster("AZ2"):
            autoscaling2 = EC2AutoScaling("autoscaling2")
            with Cluster("Public Subnet"):
                public_subnet2 = PublicSubnet("public subnet 2")

            with Cluster("Private Subnet"):
                private_subnet2 = PrivateSubnet("private subnet 2")
                ec2_2 = EC2("EC2 instance2")
            rds2 = RDS("RDS (Secondary)")

        with Cluster("ec2 Group"):
            ec2_group = [ec2_1, ec2_2]
        with Cluster("Auto Scaling Group"):
            autoscaling_group = [autoscaling1, autoscaling2]
        with Cluster("Public Subnet Group"):
            public_subnet_group = [public_subnet1, public_subnet2]

            users_01 >> internet_gateway
            internet_gateway >> elb >> public_subnet_group
            public_subnet1 >> autoscaling_group
            public_subnet2 >> autoscaling_group
            autoscaling1 >> ec2_group
            autoscaling2 >> ec2_group
            ec2_1 >> rds1
            ec2_2 >> rds2
            rds1 >> rds2 >> rds1

# from diagrams import Cluster, Diagram
# from diagrams.aws.network import InternetGateway, ElasticLoadBalancing
# from diagrams.aws.compute import EC2, EC2AutoScaling
# from diagrams.aws.database import RDS
# from diagrams.onprem.client import Users
# from diagrams.aws.network import PublicSubnet, PrivateSubnet

# with Diagram("AWS Architecture", show=True):

#     users_01 = Users("ユーザー")
#     with Cluster("AWS Cloud"):
#         internet_gateway = InternetGateway("internet gateway")

#         with Cluster("AZ1"):
#             with Cluster("Public Subnet"):
#                 elb1 = ElasticLoadBalancing("ELB")
#                 public_subnet1 = PublicSubnet("public subnet")

#             with Cluster("Private Subnet"):
#                 private_subnet1 = PrivateSubnet("private subnet")
#                 autoscaling1 = EC2AutoScaling("autoscaling")
#                 ec2_1 = EC2("EC2 instance")

#             rds1 = RDS("RDS (Primary)")

#         with Cluster("AZ2"):
#             with Cluster("Public Subnet"):
#                 elb2 = ElasticLoadBalancing("ELB")
#                 public_subnet2 = PublicSubnet("public subnet")

#             with Cluster("Private Subnet"):
#                 private_subnet2 = PrivateSubnet("private subnet")
#                 autoscaling2 = EC2AutoScaling("autoscaling")
#                 ec2_2 = EC2("EC2 instance")

#             rds2 = RDS("RDS (Secondary)")

#         users_01 >> internet_gateway
#         internet_gateway >> elb1 >> public_subnet1 >> private_subnet1 >> ec2_1
#         internet_gateway >> elb2 >> public_subnet2 >> private_subnet2 >> ec2_2
#         ec2_1 << autoscaling1 << private_subnet1
#         ec2_2 << autoscaling2 << private_subnet2
#         ec2_1 >> rds1
#         ec2_2 >> rds2


