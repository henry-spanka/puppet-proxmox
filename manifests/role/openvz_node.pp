class proxmox::role::openvz_node inherits ::proxmox::role {

	class { '::proxmox::resources::grub2':
	} ->
	class { '::proxmox::resources::kernel':
		kernel => $::proxmox::config::kernel[openvz]
  	}
  	if ($kernelrelease =~ /^.*-pve$/) {
	  	class { '::proxmox::resources::packages':
		  	require => Class['::proxmox::resources::kernel']
	  	} ->
	  	class { '::proxmox::resources::network':
	  	} ->
	  	class { '::proxmox::resources::services':
		} ->
		class { '::proxmox::profile::openvz::configuration':
		} ->
	  	class { '::proxmox::resources::certificates':
		}
	}
}
