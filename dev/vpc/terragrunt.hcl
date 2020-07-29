locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//vpc?ref=master"
}

dependency "project" {
  config_path = "../project"

  mock_outputs = {
    project_id = "aaa"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "mimo-dev"
  ip_range = "10.0.5.0/24"

  project_id = dependency.project.outputs.project_id
}
