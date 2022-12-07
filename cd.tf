# NOTE: This tf file is intended to be separate from the rest of this repo

data "harness_platform_organization" "kaizen" {
  identifier = "kaizen"
}

resource "harness_platform_project" "kaizen" {
  identifier = "Kaizen"
  name = "Kaizen"

  org_id = data.harness_platform_organization.kaizen.id
}

resource "harness_platform_template" "kmaas" {
  identifier    = "KMaaS_Vault"
  org_id        = harness_platform_project.test.org_id
  project_id    = harness_platform_project.test.id
  name          = "KMaaS_Vault"
  version       = "1"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: KMaaS_Vault
  identifier: KMaaS_Vault
  versionLabel: "1"
  type: Stage
  projectIdentifier: ${harness_platform_project.kaizen.id}
  orgIdentifier: ${data.harness_platform_organization.kaizen.id}
  tags: {}
  spec:
    type: Custom
    spec:
      execution:
        steps:
          - step:
              type: ShellScript
              name: KMaaS
              identifier: KMaaS
              spec:
                shell: Bash
                onDelegate: true
                source:
                  type: Inline
                  spec:
                    script: |-
                      #!/bin/bash
                      pwd
                      export VAULT_ADDR=$${url}
                      export VAULT_NAMESPACE=$${namespace}
                      export SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
                      export VAULT_TOKEN=$(vault write auth/$${auth_method}/login role=$${role} -path=/$${path} jwt="$SA_TOKEN" -format="json" | jq -r '.auth.client_token')

                      export secret=$(vault kv get -field="$${field}" "$${secret_path}")
                environmentVariables:
                  - name: namespace
                    type: String
                    value: <+input>
                  - name: path
                    type: String
                    value: <+input>
                  - name: role
                    type: String
                    value: <+input>
                  - name: field
                    type: String
                    value: <+input>
                  - name: secret_path
                    type: String
                    value: <+input>
                  - name: auth_method
                    type: String
                    value: <+input>
                  - name: url
                    type: String
                    value: <+input>
                outputVariables:
                  - name: secret
                    type: Secret
                    value: secret
              timeout: 10m
      EOT
}

resource "harness_platform_template" "artifactory_image_promotion" {
  identifier    = "Artifactory_Image_Promotion"
  org_id        = harness_platform_project.test.org_id
  project_id    = harness_platform_project.test.id
  name          = "Artifactory Image Promotion"
  version       = "1"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: Artifactory Image Promotion
  identifier: Artifactory_Image_Promotion
  versionLabel: "1"
  type: Stage
  projectIdentifier: ${harness_platform_project.kaizen.id}
  orgIdentifier: ${data.harness_platform_organization.kaizen.id}
  tags: {}
  spec:
    type: Custom
    spec:
      execution:
        steps:
          - step:
              type: ShellScript
              name: Artifactory Image Promotion
              identifier: Artifactory_Image_Promotion
              spec:
                shell: Bash
                onDelegate: true
                source:
                  type: Inline
                  spec:
                    script: |-
                      environment=<+stage.variables.env>
                      currentMaturity=""
                      targetMaturity=""
                      if [ $environment == "test" ]; then
                        currentMaturity="dev"
                        targetMaturity="stg"
                      fi
                      if [ $environment == "prod" ]; then
                        currentMaturity="stg"
                        targetMaturity="rel"
                      fi

                      curl --cacert /tmp/art-ca.crt -H "Authorization: Bearer <+pipeline.stages.Configure_KMaaS.spec.execution.steps.KMaaS.output.outputVariables.secret>" -i -X POST "https://artifactory_url:443/artifactory/api/docker/<+pipeline.variables.artifactoryRepo>-$currentMaturity-local/v2/promote" -H "Content-Type: application/json" -d '{"targetRepo":"<+pipeline.variables.artifactoryRepo>-'$targetMaturity'-local","dockerRepository":"<+pipeline.variables.imageName>/<+pipeline.variables.imageTag>"}'
                environmentVariables: []
                outputVariables: []
              timeout: 1m
    variables:
      - name: env
        type: String
        description: ""
        value: <+input>
    when:
      pipelineStatus: Success
      condition: <+pipeline.variables.branch> != "master" && <pipeline.variables.branch> != "main"

  EOT
}

resource "harness_platform_pipeline" "image_promotion" {
  identifier = "Image_Promotion"
  org_id     = data.harness_platform_organization.kaizen.id
  project_id = harness_platform_project.kaizen.id
  name       = "Image Promotion"
  yaml = <<-EOD
pipeline:
  name: Image Promotion
  identifier: Image_Promotion
  projectIdentifier: ${harness_platform_project.kaizen.id}
  orgIdentifier: ${data.harness_platform_organization.kaizen.id}
  tags: {}
  stages:
    - stage:
        name: Configure KMaaS
        identifier: Configure_KMaaS
        template:
          templateRef: ${harness_platform_template.kmaas.identifier}
          versionLabel: "1"
          templateInputs:
            type: Custom
            spec:
              execution:
                steps:
                  - step:
                      identifier: KMaaS
                      type: ShellScript
                      spec:
                        environmentVariables:
                          - name: namespace
                            type: String
                            value: namespace
                          - name: path
                            type: String
                            value: path
                          - name: role
                            type: String
                            value: role
                          - name: field
                            type: String
                            value: field
                          - name: secret_path
                            type: String
                            value: secret
                          - name: auth_method
                            type: String
                            value: method
                          - name: url
                            type: String
                            value: url
    - stage:
        name: Trigger Details
        identifier: Trigger_Details
        description: ""
        type: Custom
        spec:
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Print Trigger Details
                  identifier: Print_Trigger_Details
                  spec:
                    shell: Bash
                    onDelegate: true
                    source:
                      type: Inline
                      spec:
                        script: |-
                          cat << EOF
                          Artifactory Repo: <+pipeline.variables.artifactoryRepo>
                          Image: <+pipeline.variables.imageName>:<+pipeline.variables.imageTag>
                          Github Repo: <+pipeline.variables.githubRepo>
                          Branch: <+pipeline.variables.branch>
                          EOF
                    environmentVariables: []
                    outputVariables: []
                  timeout: 1m
        tags: {}
    - stage:
        name: Promote Image To Stg
        identifier: Promote_Image_To_Stg
        description: ""
        type: Approval
        spec:
          execution:
            steps:
              - step:
                  name: Promote Image To Staging
                  identifier: Promote_Image_To_Staging
                  type: HarnessApproval
                  timeout: 1d
                  spec:
                    approvalMessage: |-
                      Please review the following information
                      and approve the pipeline progression
                    includePipelineExecutionHistory: true
                    approvers:
                      minimumCount: 1
                      disallowPipelineExecutor: false
                      userGroups:
                        - _project_all_users
                    approverInputs: []
                  when:
                    stageStatus: Success
                  failureStrategies: []
        tags: {}
        when:
          pipelineStatus: Success
          condition: <+pipeline.variables.branch> != "master" && <pipeline.variables.branch> != "main"
    - stage:
        name: Stg Image Promotion
        identifier: Stg_Image_Promotion
        template:
          templateRef: ${harness_platform_template.artifactory_image_promotion.identifier}
          versionLabel: "1"
          templateInputs:
            type: Custom
            variables:
              - name: env
                type: String
                value: stg
    - stage:
        name: Promote Image To Prod
        identifier: Promote_Image_To_Prod
        description: ""
        type: Approval
        spec:
          execution:
            steps:
              - step:
                  name: Promote Image To Prod
                  identifier: Promote_Image_To_Prod
                  type: HarnessApproval
                  timeout: 1d
                  spec:
                    approvalMessage: |-
                      Please review the following information
                      and approve the pipeline progression
                    includePipelineExecutionHistory: true
                    approvers:
                      minimumCount: 1
                      disallowPipelineExecutor: true
                      userGroups:
                        - _project_all_users
                    approverInputs: []
                  failureStrategies: []
        tags: {}
        when:
          pipelineStatus: Success
          condition: <+pipeline.variables.branch> != "master" && <pipeline.variables.branch> != "main"
    - stage:
        name: Prod Image Promotion
        identifier: Prod_Image_Promotion
        template:
          templateRef: ${harness_platform_template.artifactory_image_promotion.identifier}
          versionLabel: "1"
          templateInputs:
            type: Custom
            variables:
              - name: env
                type: String
                value: prod
    - stage:
        name: KMaaS GithubPAT
        identifier: KMaaS_GithubPAT
        template:
          templateRef: ${harness_platform_template.kmaas.identifier}
          versionLabel: "1"
          templateInputs:
            type: Custom
            spec:
              execution:
                steps:
                  - step:
                      identifier: KMaaS
                      type: ShellScript
                      spec:
                        environmentVariables:
                          - name: namespace
                            type: String
                            value: namespace
                          - name: path
                            type: String
                            value: path
                          - name: role
                            type: String
                            value: role
                          - name: field
                            type: String
                            value: field
                          - name: secret_path
                            type: String
                            value: secret
                          - name: auth_method
                            type: String
                            value: method
                          - name: url
                            type: String
                            value: url
    - stage:
        name: Create Github Release
        identifier: Create_Github_Release
        description: ""
        type: Custom
        spec:
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Create Github Release
                  identifier: Create_Github_Release
                  spec:
                    shell: Bash
                    onDelegate: true
                    source:
                      type: Inline
                      spec:
                        script: |-
                          # https://developer.github.com/v3/repos/releases/#create-a-release

                          curl -X POST  -H "Accept: application/vnd.github.v3+json"  -H "Authorization: token <+pipeline.stages.KMaaS_GithubPAT.spec.execution.steps.KMaaS.output.outputVariables.secret>" --data '{"tag_name": "<+pipeline.variables.imageTag>","name": "<+pipeline.variables.imageName>:<+pipeline.variables.imageTag>","body": "Container image available from Artifactory: <+pipeline.variables.artifactoryRepo>-<+stage.variables.env>.artifactory_url/<+pipeline.variables.imageName>:<+pipeline.variables.imageTag> - View in Artifactory: <https://artifactory_url/ui/repos/tree/General/<+pipeline.variables.artifactoryRepo>-<+stage.variables.env>/<+pipeline.variables.imageName>/<+pipeline.variables.imageTag>>", "draft": false, "prerelease": false,"generate_release_notes":true}' "https://api.github.com/repos/<+pipeline.variables.githubRepo>/releases"
                    environmentVariables: []
                    outputVariables: []
                    delegateSelectors:
                      - <+stage.variables.env>
                  timeout: 1m
                  failureStrategies: []
        tags: {}
        when:
          pipelineStatus: Success
          condition: <+pipeline.variables.branch> != "master" && <pipeline.variables.branch> != "main"
        variables:
          - name: env
            type: String
            description: ""
            value: prod
    - stage:
        name: Jenkins Trigger
        identifier: Jenkins_Trigger
        description: ""
        type: Custom
        spec:
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Shell Script
                  identifier: ShellScript
                  spec:
                    shell: Bash
                    onDelegate: true
                    source:
                      type: Inline
                      spec:
                        script: |-
                          dockerRepo=<+pipeline.variables.artifactoryRepo>
                          if [[ $dockerRepo != *"-remote"* ]]; then
                            dockerRepo=<+pipeline.variables.artifactoryRepo>-prod
                          fi
                    environmentVariables: []
                    outputVariables:
                      - name: dockerRepo
                        type: String
                        value: dockerRepo
                  timeout: 1m
        tags: {}
  variables:
    - name: imageName
      type: String
      description: ""
      value: <+input>
    - name: githubRepo
      type: String
      description: ""
      value: <+input>
    - name: artifactoryRepo
      type: String
      description: ""
      value: <+input>
    - name: imageTag
      type: String
      description: ""
      value: <+input>
    - name: branch
      type: String
      description: ""
      value: <+input>

  EOD

}