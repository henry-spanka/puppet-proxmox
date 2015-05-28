class proxmox::resources::bashrc {
    
    if ($::proxmox::config::custom_bashrc) {
        file { '/root/.bashrc':
            ensure => file,
            owner => root,
            group => root,
            mode => 644,
            source => 'puppet:///modules/proxmox/bashrc/bashrc'
        }
    }
}