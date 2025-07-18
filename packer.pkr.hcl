packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  vm_name          = var.vm_name
  iso_url          = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
  iso_checksum     = "auto"
  guest_os_type    = "Ubuntu_64"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_wait_timeout = "20m"
  http_directory   = "http"
  boot_command = [
    "<esc><wait>",
    "install autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<enter>"
  ]
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  disk_size        = 10240
  headless         = true

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "1024"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'Provisioning minimal system...'"
    ]
  }

  post-processor "vagrant" {
    output = "ubuntu-2404-minimal.box"
  }
}

