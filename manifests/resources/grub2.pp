class proxmox::resources::grub2 {
	if ($::proxmox::config::grub2_version) {
		package { "grub-pc":
			ensure => $::proxmox::config::grub2_version,
			require => Exec['apt_update']
		} ->
		package { "grub-pc-bin":
			ensure => $::proxmox::config::grub2_version
		} ->
		package { "grub2-common":
			ensure => $::proxmox::config::grub2_version
		} ->
		package { "grub-common":
			ensure => $::proxmox::config::grub2_version
		}
	}
}