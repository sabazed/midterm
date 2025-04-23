provider "local" {}

variable "deploy_path" {
  type = string
}

locals {
  deploy_path = var.deploy_path
}

resource "null_resource" "create_deploy_folders" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ${local.deploy_path}/midterm-blue
      mkdir -p ${local.deploy_path}/midterm-green
      mkdir -p ${local.deploy_path}/midterm-current

      # This is necessary to clean up any existing directories with Windows-style line endings
      find ${local.deploy_path} -type d -exec bash -c 'mv "$0" "$(echo "$0" | tr -d "\r")"' {} \;
    EOT
  }
}
