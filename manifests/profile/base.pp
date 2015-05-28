# The base profile for Proxmox. Installs the repository, fixes /etc/hosts file and ntp
class proxmox::profile::base {
  # make sure the parameters are initialized
  include ::proxmox

  # everyone also needs to be on the same clock
  include ::ntp

  # install custom bashrc if needed
  class { '::proxmox::resources::bashrc': }
  # fix /etc/hosts for all nodes
  class { '::proxmox::resources::hosts': }
  # all nodes need the Proxmox repositories
  class { '::proxmox::resources::repo': }

}
