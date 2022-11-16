module "org" {
  source = "./modules/org"

  org_identifier = var.org_id
  org_name       = var.org_name
}

# resource "harness_platform_project" "Kaizen" {
#   identifier = "Kaizen"
#   name = "Kaizen"

#   org_id = module.org["Payments"].org_id
# }

# resource "harness_platform_pipeline" "Kaizen_Java" {
#   identifier = "Kaizen_Java"
#   org_id     = module.org["Payments"].org_id
#   project_id = harness_platform_project.Kaizen.id
#   name       = "Kaizen Java"
#   yaml = <<-EOF
# pipeline:
#   name: Kaizen Java
#   identifier: Kaizen_Java
#   projectIdentifier: ${harness_platform_project.Kaizen.id}
#   orgIdentifier: ${module.org["Payments"].org_id}
#   tags: {}
#   stages:
#     - stage:
#         name: echo
#         identifier: echo
#         description: ""
#         type: Custom
#         spec:
#           execution:
#             steps:
#               - step:
#                   type: ShellScript
#                   name: echo
#                   identifier: echo
#                   spec:
#                     shell: Bash
#                     onDelegate: true
#                     source:
#                       type: Inline
#                       spec:
#                         script: echo "hello world!, <+pipeline.name>, "
#                     environmentVariables: []
#                     outputVariables: []
#                   timeout: 1m
#                   failureStrategies: []
#         tags: {}
#     - stage:
#         name: prod approval
#         identifier: prod_approval
#         description: Proceed?
#         type: Approval
#         spec:
#           execution:
#             steps:
#               - step:
#                   name: prod approval
#                   identifier: prod_approval
#                   type: HarnessApproval
#                   timeout: 1d
#                   spec:
#                     approvalMessage: |-
#                       Please review the following information
#                       and approve the pipeline progression
#                     includePipelineExecutionHistory: true
#                     approvers:
#                       minimumCount: 1
#                       disallowPipelineExecutor: false
#                       userGroups:
#                         - org.${module.org["Payments"].org_approver_usergroup_id}
#                     approverInputs: []
#   EOF

# }