output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.response_body
}

output "externaldns_iam_policy_arn" {
  value = aws_iam_policy.externaldns_iam_policy.arn 
} 

output "externaldns_iam_role_arn" {
  value = aws_iam_role.externaldns_iam_role.arn
} 

output "externaldns_id" {
  value = helm_release.external_dns.id
} 

# Helm Release Outputs
output "lbc_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.loadbalancer_controller.metadata
}

output "lbc_controller_id" {
  description = "Id of the deployed release."
  value = helm_release.loadbalancer_controller.id
}

output "externaldns_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.external_dns.metadata
}

