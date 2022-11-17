# harness-tf-rbac

Example terraform module to manage organisation RBAC resource creation in Harness.

## Terraform backend state configuration

For the demo this was setup with the `azurerm` backend provider, this will likely want to be changed to S3 and some different variables will be required.

Backend state overrides have been configured in the terraform plan step advanced configuration, this can be replaced with the appropriate s3 backend config.
Note the `key` field used for azurerm backend, this should remain the same for s3 configuration.

## Connectors

References to my own connectors on my own account e.g. github connector have been left as they were. Will need to change these to your own connector references

