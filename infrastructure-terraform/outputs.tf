output "vpc_arn" {
  value=module.vpc.vpc_arn
}
output "eks_arn" {
   value=module.eks.cluster_arn
}
output "ecr_repository_url" {
   value=module.ecr.repository_url
}
# output "all_vpc_module"{
#    value=module.vpc
# }