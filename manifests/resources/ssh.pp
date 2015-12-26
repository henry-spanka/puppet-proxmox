# Manages SSH module
class proxmox::resources::ssh {

  class { 'apt::backports': }

  apt::pin { 'backports_openssh':
    packages => [
      'openssh-server',
      'openssh-client'
    ],
    priority => 500,
    release  => 'wheezy-backports',
    before => Class['::ssh']
  }
    
  class { '::ssh':
    client_options => $::proxmox::config::ssh_client_options,
    server_options => $::proxmox::config::ssh_server_options,
    storeconfigs_enabled => $::proxmox::config::ssh_storeconfigs_enabled,
    version => $::proxmox::config::ssh_version,
    require => Class['apt::backports']
  }
}
