packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}

source "hyperv-vmcx" "redhat" {
  clone_from_vm_name = "RedHat-Seed"
  shutdown_command   = "echo 'packer' | sudo -S -E shutdown -P now"

  generation   = "2"
  boot_wait    = "4s"
  switch_name  = "Default Switch"
  ssh_username = "packer"
  ssh_password = "packer"

  headless    = true
  skip_export = true
}

build {
  sources = [
    "source.hyperv-vmcx.redhat"
  ]

  # lazy install
  provisioner "file" {
    source      = "cloud-init"
    destination = "/tmp/cloud-init"
  }

  provisioner "file" {
    source      = "cloud-init-module"
    destination = "/tmp/cloud-init-module"
  }

  provisioner "shell" {
    inline = [
      "sudo cp -rf /tmp/cloud-init/* /etc/cloud/",
      "sudo cp -rf /tmp/cloud-init-module/* /usr/lib/python3.9/site-packages/cloudinit/config/",
    ]
  }

  # cloud init data
  provisioner "file" {
    source      = "user-data.yaml"
    destination = "/tmp/user-data"
  }

  provisioner "file" {
    source      = "meta-data"
    destination = "/tmp/meta-data"
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /var/lib/cloud/seed/nocloud-net",
      "sudo mv /tmp/user-data /var/lib/cloud/seed/nocloud-net/user-data",
      "sudo mv /tmp/meta-data /var/lib/cloud/seed/nocloud-net/meta-data",
      "sudo cloud-init init",
      "sudo cloud-init modules --mode config",
      "sudo cloud-init modules --mode final"
    ]
  }

  provisioner "breakpoint" {
    note = "this is a breakpoint"
  }
}