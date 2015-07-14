class proxmox::role::kvm_node inherits ::proxmox::role {

    class { '::proxmox::resources::grub2':
    } ->
    class { '::proxmox::resources::kernel':
        kernel => $::proxmox::config::kernel[kvm]
    }
    if ($kernelrelease =~ /^.*-pve$/) {
        class { '::proxmox::resources::packages':
            require => Class['::proxmox::resources::kernel']
        } ->
        class { '::proxmox::resources::network':
        } ->
    	class { '::proxmox::resources::certificates':
    	} ->
        class { '::proxmox::resources::backups':
        } ->
        class { '::proxmox::resources::services':
        } ->
        class { '::proxmox::profile::kvm::configuration':
        }
    }
}
