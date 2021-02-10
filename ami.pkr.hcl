source "amazon-ebs" "rstudio-connect" {
  ami_description = "RStudioConnect v${var.rstudio_connect_version} with R v${var.r_version}"
  ami_name        = "RStudioConnect-${var.rstudio_connect_version}-R-${var.r_version}-${formatdate("DDMMMYYYY-hhmmssZZZ", timestamp())}"
  ami_regions     = [var.aws_region]
  ena_support     = "true"
  encrypt_boot    = "true"
  instance_type   = "t3.medium"
  region          = var.aws_region
  source_ami_filter {
    filters = {
      name                = "CentOS Stream 8 x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["125523088429"]
  }
  ssh_username = "centos"
  tags = {
    RStudioConnectVersion = var.rstudio_connect_version
    RVersion              = var.r_version
  }
}

build {
  sources = ["source.amazon-ebs.rstudio-connect"]

  provisioner "shell" {
    inline = [
      "sleep 10",
      "sudo yum update -y",
      "sudo yum install python3 python3-pip -y",
      "sudo pip3 install -q ansible==2.8.18 awscli",
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
    role_paths    = [
      "./roles/base",
      "./roles/python3",
      "./roles/r",
      "./roles/rstudio-connect",
    ]
    extra_arguments = [
      "--extra-vars",
      "\"r_version=${var.r_version} rstudio_connect_version=${var.rstudio_connect_version}\"",
    ]
  }

  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }
}
