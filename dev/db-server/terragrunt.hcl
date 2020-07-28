locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//db-server?ref=master"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "aaa"
    ip_range = "aa"
  }
}

dependency "project" {
  config_path = "../project"

  mock_outputs = {
    project_id  = "aaa"
    internal_domain_name = "aaa"
  }
}

inputs = merge(
  local.env_variables.locals,
  {
    droplet_name  = "mimo-db"
    image_name = "database-1595910892"
    size  = "s-1vcpu-1gb"
    ssh_keys = [22442613]

    project_name = dependency.project.outputs.project_id
    domain_name  = dependency.project.outputs.internal_domain_name
    vpc_id       = dependency.vpc.outputs.vpc_id
    internal_ip_range = dependency.vpc.outputs.ip_range
  }
)
