terraform {
  required_providers {
    honeycombio = {
      source = "honeycombio/honeycombio"
      version = "0.13.0"
    }
  }
}

provider "honeycombio" {
  # Configuration options
}

module "deployments" {
  source = "./deployments"

}

output "deployments" {
  value = module.deployments

}