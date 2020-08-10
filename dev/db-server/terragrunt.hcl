locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//server?ref=master"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id   = "aaa"
    ip_range = "aa"
  }
}

dependency "project" {
  config_path = "../project"

  mock_outputs = {
    project_id           = "aaa"
    internal_domain_name = "aaa"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  droplet_name        = "mimo-db"
  image_name          = "database-1595910892"
  size                = "s-1vcpu-1gb"
  ssh_keys            = [22442613]
  private_record_name = "db"

  firewall_name = "ssh-db-access"
  firewall_inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "5432"
      source_addresses = [dependency.vpc.outputs.ip_range]
    },
  ]
  firewall_outbound_rules = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0"]
    },
  ]

  project_name = dependency.project.outputs.project_id
  domain_name  = dependency.project.outputs.internal_domain_name
  vpc_id       = dependency.vpc.outputs.vpc_id
}
