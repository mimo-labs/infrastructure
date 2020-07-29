locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

remote_state {
  backend = "local"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

inputs = local.env_variables.locals
