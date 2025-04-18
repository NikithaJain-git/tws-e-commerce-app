locals {

    region  = eu-west-1
    name    = "easyshop-eks-cluster"
    vpc_cidr = "10.0.0.0/16"
    azs =  ["eu-west-1a","eu-west-1b"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    intra_subnets = ["10.0.5.0/24", "10.0.6.0/24"]
    tags =  {
        example = local.name
    }

  node_groups = {
    ng-1 = {
      name          = "tws-demo-ng-1"
      instance_type = "t2.large"
    }
    ng-2 = {
      name          = "tws-demo-ng-2"
      instance_type = "t2.large"
    }
  }
}

provider "aws" {
    region = local.region
}
