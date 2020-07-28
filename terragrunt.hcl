locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = local.env_variables.locals
