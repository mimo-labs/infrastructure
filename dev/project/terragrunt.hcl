locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//project?ref=master"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project_name         = "Mimo"
  external_domain_name = "mime.rocks"
}
