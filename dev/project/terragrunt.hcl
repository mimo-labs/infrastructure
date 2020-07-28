locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//project?ref=master"
}

inputs = merge(
  local.env_variables.locals,
  {
    project_name = "Mimo"
  }
)
