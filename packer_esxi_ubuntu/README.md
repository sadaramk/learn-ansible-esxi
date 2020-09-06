# WARNING #
Had to roll back to esxi 6.7 due to no support for VNC https://github.com/hashicorp/packer/pull/9895

# Enable SSH
Navigate to "Manage", then the "Services" tab. Find the entry called "TSM-SSH”, and enable it. To enable it at start up click on "Actions" and select "start and stop with host" under "Policy"

### Allow network communication for Packer

* Download init script to local PC:
  ```bash
  wget http://raw.githubusercontent.com/sadaramk/setup-esxi-homelab/master/local.sh
  ```

* Copy init script to ESXi host via SSH
  ```bash
  scp local.sh root@esxi:/etc/rc.local.d/local.sh
  ```

* Make init script executable on ESXi host
  ```bash
  ssh root@esxi chmod +x /etc/rc.local.d/local.sh
  ```

* Execute init script on ESXi host once
  ```bash
  ssh root@esxi /etc/rc.local.d/local.sh
  ```


# Execute
packer build -var-file variables.json ubuntu.json


# Credit
https://www.infralovers.com/en/articles/2019/10/15/automated-vmware-templates-with-hashicorp-packer/
https://github.com/chrisipa/packer-esxi