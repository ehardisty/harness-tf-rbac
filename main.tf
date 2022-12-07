module "org" {
  source = "./modules/org"

  org_identifier = var.org_id
  org_name       = var.org_name
}

