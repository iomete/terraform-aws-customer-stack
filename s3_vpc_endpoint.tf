resource "aws_vpc_endpoint" "this" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [module.vpc.default_route_table_id]

  tags = local.tags

  depends_on = [
    module.eks
  ]
}
