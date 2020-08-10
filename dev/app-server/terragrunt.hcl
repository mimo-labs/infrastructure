locals {
  env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "git::git@github.com:mimo-mocks/terraform-modules.git//server?ref=master"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "aaa"
  }
}

dependency "project" {
  config_path = "../project"

  mock_outputs = {
    project_id           = "aaa"
    internal_domain_name = "aaa"
    external_domain_name = "aaa"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  droplet_name        = "mimo-app"
  image_name          = "apiserver-1595819694"
  size                = "s-1vcpu-1gb"
  ssh_keys            = [22442613]
  public_record_name  = "dev"
  private_record_name = "app"

  firewall_name = "ssh-web-access"
  firewall_inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0"]
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

  project_name         = dependency.project.outputs.project_id
  domain_name          = dependency.project.outputs.internal_domain_name
  external_domain_name = dependency.project.outputs.external_domain_name
  vpc_id               = dependency.vpc.outputs.vpc_id
}
