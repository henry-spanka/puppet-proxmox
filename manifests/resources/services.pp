class proxmox::resources::services {

    service { 'pve-cluster':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true
    }
    service { 'pvedaemon':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false
    }  
    service { 'pveproxy':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false
    }
    service { 'pvestatd':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false
    }
    service { 'spiceproxy':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false
    }
    service { 'pve-firewall':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false
    }

    if ($proxmoxcluster == 'true') {
        service { 'cman':
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => true
        }
    }
    if ($::proxmox::config::package_versions['pve-database']) {
        service { 'pvedatabased':
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => false,
        }
        service { 'novncproxy':
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => false
        }
    }
}