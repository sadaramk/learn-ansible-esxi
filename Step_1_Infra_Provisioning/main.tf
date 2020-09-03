
provider "esxi" {
  esxi_hostname      = var.esxi_hostname
  esxi_hostport      = var.esxi_hostport
  esxi_hostssl       = var.esxi_hostssl
  esxi_username      = var.esxi_username
  esxi_password      = var.esxi_password
}

#
# Template for initial configuration bash script
#    template_file is a great way to pass variables to
#    cloud-init
data "template_file" "userdata_default" {
  template = file("userdata.tpl")
  vars = {
    HOSTNAME = var.vm_hostname
    HELLO    = "Hello EXSI World!"
  }
}


resource "esxi_guest" "vmtest" {
  guest_name         = var.vm_hostname
  disk_store         = var.disk_store
  ovf_source         = var.vm_cloud_ova


  #
  #  Specify an existing guest to clone, an ovf source, or neither to build a bare-metal guest vm.
  #
  #clone_from_vm      = "Templates/centos7"
  #ovf_source        = "/local_path/centos-7.vmx"

  network_interfaces {
    virtual_network = var.virtual_network
  }

  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.userdata_default.rendered)
  }

  ovf_properties {
    key = "password"
    value = "Passw0rd1"
  }

  ovf_properties {
    key = "hostname"
    value = "HelloWorld"
  }

  ovf_properties {
    key = "user-data"
    value = base64encode(data.template_file.userdata_default.rendered)
  }
}