packer {
  required_version = "~> 1.8.0"
  required_plugins {
     qemu = {
       version = ">= 1.0.2"
       source  = "github.com/hashicorp/qemu"
     }
  }
}

source "qemu" "fedora-workstation" {
  vm_name   = "Fedora"
  qemuargs  = [
    [ "-cpu", "host,migratable=on,topoext=on,apic=on,hypervisor=on,invtsc=on,hv-time=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x1fff,hv-vpindex=on,hv-synic=on,hv-stimer=on,hv-reset=on,hv-vendor-id=kvm hyperv,hv-frequencies=on,kvm=off,host-cache-info=on,l3-cache=off" ],
    [ "-smp", "12,sockets=1,dies=1,cores=6,threads=2" ],
  ]
  firmware = "/usr/share/OVMF/OVMF_CODE.fd"
  memory = 12288
  net_device = "virtio-net-pci"
  net_bridge = "virbr2"
  boot_command         = [
        "<up>e<down><down><end><wait>",
        "<bs><bs><bs><bs><bs><wait>",
        "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart.cfg quiet<leftCtrlOn>x<leftCtrlOff>"
  ]

  boot_wait            = "5s"
  shutdown_command     = "shutdown -h now"
  output_directory     = "artifacts/qemu/FedoraWorkstation"

  disk_interface  = "virtio"
  disk_size       = "50G"
  disk_discard    = "unmap"
  format          = "qcow2"
  accelerator     = "kvm"
  iso_url         = "./iso/Fedora-Server-netinst-x86_64-35-1.2.iso"
  iso_checksum    = "md5:e35efe2a035f72ae5031ac6a4aa464fc"
  http_directory  = "http"

  ssh_username    = "root"
  ssh_password    = "packer"

  ssh_wait_timeout = "3h"
  ssh_handshake_attempts = "5000"
}

build {

  sources = ["source.qemu.fedora-workstation"]

  # provisioner "shell" {
  #     execute_command = "sudo -E bash '{{ .Path }}'"
  #     inline = [
  #       "dnf -y install ansible"
  #     ]
  # }

  # provisioner "ansible-local" {
  #   playbook_file   = "./ansible/playbook.yml"
  #   playbook_dir    = "./ansible/"
  #   clean_staging_directory = true
  #   staging_directory = "/tmp/ansible-packer"
  # }

}
