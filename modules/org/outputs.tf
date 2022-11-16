output "org_id" {
  value = harness_platform_organization.team.id
}

output "org_approver_usergroup_id" {
  value = harness_platform_usergroup.team_approver.id
}