terraform {
  required_providers {
    harness = {
      source = "registry.terraform.io/harness/harness"
      version = "0.7.1"
    }
  }
}

resource "harness_platform_organization" "team" {
  identifier = var.org_identifier
  name       = var.org_name
}

resource "harness_platform_usergroup" "team_admin" {
  identifier           = "${var.org_identifier}_Admins"
  name                 = "${var.org_name} Admins"
  org_id             = harness_platform_organization.team.id
  # linked_sso_id      = "Harness_DEV"
  # externally_managed = false
  # linked_sso_display_name = "Harness DEV"
  # sso_group_id            = "CLP_SaaS_Harness_${var.org_identifier}_Admins"
  # sso_group_name          = "CLP_SaaS_Harness_${var.org_identifier}_Admins"
  # linked_sso_type         = "SAML"
  # sso_linked              = true
}

resource "harness_platform_usergroup" "team_executor" {
  identifier           = "${var.org_identifier}_Executors"
  name                 = "${var.org_name} Executors"
  org_id             = harness_platform_organization.team.id
  # linked_sso_id      = "Harness_DEV"
  # externally_managed = false
  # linked_sso_display_name = "Harness DEV"
  # sso_group_id            = "CLP_SaaS_Harness_${var.org_identifier}_Executors"
  # sso_group_name          = "CLP_SaaS_Harness_${var.org_identifier}_Executors"
  # linked_sso_type         = "SAML"
  # sso_linked              = true
}

resource "harness_platform_usergroup" "team_readonly" {
  identifier           = "${var.org_identifier}_ReadOnly"
  name                 = "${var.org_name} ReadOnly"
  org_id             = harness_platform_organization.team.id
  # linked_sso_id      = "Harness_DEV"
  # externally_managed = false
  # linked_sso_display_name = "Harness DEV"
  # sso_group_id            = "CLP_SaaS_Harness_${var.org_identifier}_ReadOnly"
  # sso_group_name          = "CLP_SaaS_Harness_${var.org_identifier}_ReadOnly"
  # linked_sso_type         = "SAML"
  # sso_linked              = true
}

resource "harness_platform_usergroup" "team_approver" {
  identifier           = "${var.org_identifier}_Approvers"
  name                 = "${var.org_name} Approvers"
  org_id             = harness_platform_organization.team.id
  # linked_sso_id      = "Harness_DEV"
  # externally_managed = false
  # linked_sso_display_name = "Harness DEV"
  # sso_group_id            = "CLP_SaaS_Harness_${var.org_identifier}_Approvers"
  # sso_group_name          = "CLP_SaaS_Harness_${var.org_identifier}_Approvers"
  # linked_sso_type         = "SAML"
  # sso_linked              = true
}

resource "harness_platform_roles" "team_admin" {
  identifier           = "${var.org_identifier}_admins"
  name                 = "${var.org_name} Admins"
  org_id               = harness_platform_organization.team.id
  description          = "Admin Role for the ${var.org_name} team"
  allowed_scope_levels = ["organization"]

  permissions = [
    "core_template_view",
    "core_governancePolicy_view",
    "core_serviceaccount_view",
    "core_governancePolicy_delete",
    "core_resourcegroup_view",
    "core_secret_edit",
    "core_governancePolicySets_delete",
    "core_pipeline_view",
    "core_user_view",
    "core_delegateconfiguration_edit",
    "core_file_delete",
    "core_project_delete",
    "core_role_view",
    "core_file_access",
    "core_governancePolicySets_evaluate",
    "core_secret_delete",
    "core_delegateconfiguration_view",
    "core_organization_view",
    "core_delegate_delete",
    "core_project_create",
    "core_template_edit",
    "core_secret_view",
    "core_project_edit",
    "core_secret_access",
    "core_environmentgroup_edit",
    "core_service_view",
    "core_governancePolicy_edit",
    "core_setting_view",
    "core_service_edit",
    "core_dashboards_edit",
    "core_governancePolicySets_edit",
    "core_delegateconfiguration_delete",
    "core_environment_view",
    "core_environmentgroup_access",
    "core_service_delete",
    "core_usergroup_view",
    "core_environmentgroup_view",
    "core_connector_view",
    "core_governancePolicySets_view",
    "core_environmentgroup_delete",
    "core_variable_edit",
    "core_environment_access",
    "core_environment_delete",
    "core_file_view",
    "core_delegate_view",
    "core_variable_delete",
    "core_template_access",
    "core_pipeline_delete",
    "core_dashboards_view",
    "core_project_view",
    "core_connector_edit",
    "core_service_access",
    "core_pipeline_edit",
    "core_template_delete",
    "core_connector_access",
    "core_pipeline_execute",
    "core_delegate_edit",
    "core_variable_view",
    "core_environment_edit",
    "core_connector_delete",
    "core_file_edit"
  ]


}

resource "harness_platform_roles" "team_executor" {
  identifier           = "${var.org_identifier}_executors"
  name                 = "${var.org_name} Executors"
  org_id               = harness_platform_organization.team.id
  description          = "Executor Role for the ${var.org_name} team"
  allowed_scope_levels = ["organization"]

  permissions = [
    "core_setting_view",
    "core_template_view",
    "core_governancePolicy_view",
    "core_delegateconfiguration_view",
    "core_environment_view",
    "core_delegate_view",
    "core_dashboards_view",
    "core_project_view",
    "core_pipeline_view",
    "core_secret_view",
    "core_environmentgroup_view",
    "core_service_access",
    "core_connector_view",
    "core_governancePolicySets_view",
    "core_pipeline_execute",
    "core_service_view",
    "core_variable_view",
    "core_file_view"
  ]

}


resource "harness_platform_roles" "team_readonly" {
  identifier           = "${var.org_identifier}_viewers"
  name                 = "${var.org_name} Viewers"
  org_id               = harness_platform_organization.team.id
  description          = "Read-only Role for the ${var.org_name} team"
  allowed_scope_levels = ["organization"]

  permissions = [
    "core_setting_view",
    "core_serviceaccount_view",
    "core_template_view",
    "core_governancePolicy_view",
    "core_delegateconfiguration_view",
    "core_resourcegroup_view",
    "core_organization_view",
    "core_delegate_view",
    "core_environment_view",
    "core_dashboards_view",
    "core_usergroup_view",
    "core_project_view",
    "core_secret_view",
    "core_pipeline_view",
    "core_environmentgroup_view",
    "core_connector_view",
    "core_user_view",
    "core_governancePolicySets_view",
    "core_service_view",
    "core_variable_view",
    "core_role_view",
    "core_file_view"
  ]

}

resource "harness_platform_role_assignments" "admin_role_binding" {
  identifier                = "${var.org_identifier}_admin_rolebinding"
  org_id                    = harness_platform_organization.team.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = harness_platform_roles.team_admin.id
  principal {
    identifier = harness_platform_usergroup.team_admin.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
}

resource "harness_platform_role_assignments" "executors_role_binding" {
  identifier                = "${var.org_identifier}_executors_rolebinding"
  org_id                    = harness_platform_organization.team.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = harness_platform_roles.team_executor.id
  principal {
    identifier = harness_platform_usergroup.team_executor.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
}

resource "harness_platform_role_assignments" "readonly_role_binding" {
  identifier                = "${var.org_identifier}_readonly_rolebinding"
  org_id                    = harness_platform_organization.team.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = harness_platform_roles.team_readonly.id
  principal {
    identifier = harness_platform_usergroup.team_readonly.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
}