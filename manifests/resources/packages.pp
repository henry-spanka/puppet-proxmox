# Package Resource
class proxmox::resources::packages {
    
    $package_versions = $::proxmox::config::package_versions

    package { 'rsync':
        ensure => installed
    }
    package { 'tar':
        ensure => installed
    }
    package { 'openssh-client':
        ensure => installed,
    }
    
    package { 'pve-firmware':
        ensure => $package_versions['pve-firmware']
    } ->
    package { 'corosync-pve':
        ensure => $package_versions['corosync-pve']
    } ->
    package { 'glusterfs-client':
        ensure => $package_versions['glusterfs-client']
    } ->
    package { 'ksm-control-daemon':
        ensure => $package_versions['ksm-control-daemon']
    } ->
    package { 'pve-libspice-server1':
        ensure => $package_versions['pve-libspice-server1']
    } ->
    package { 'openais-pve':
        ensure => $package_versions['openais-pve']
    } ->
    package { 'libpve-common-perl':
        ensure => $package_versions['libpve-common-perl']
    } ->
    package { 'pve-cluster':
        ensure => $package_versions['pve-cluster']
    } ->
    package { 'redhat-cluster-pve':
        ensure => $package_versions['redhat-cluster-pve']
    } ->
    package { 'fence-agents-pve':
        ensure => $package_versions['fence-agents-pve']
    } ->
    package { 'resource-agents-pve':
        ensure => $package_versions['resource-agents-pve']
    } ->
    package { 'libpve-access-control':
        ensure => $package_versions['libpve-access-control']
    } ->
    package { 'libpve-storage-perl':
        ensure => $package_versions['libpve-storage-perl']
    } ->
    package { 'pve-qemu-kvm':
        ensure => $package_versions['pve-qemu-kvm']
    } ->
    package { 'vzquota':
        ensure => $package_versions['vzquota']
    } ->
    package { 'vzprocps':
        ensure => $package_versions['vzprocps']
    } ->
    package { 'vzctl':
        ensure => $package_versions['vzctl']
    } ->
    package { 'vncterm':
        ensure => $package_versions['vncterm']
    } ->
    package { 'novnc-pve':
        ensure => $package_versions['novnc-pve']
    } ->
    package { 'qemu-server':
        ensure => $package_versions['qemu-server']
    } ->
    package { 'pve-manager':
        ensure => $package_versions['pve-manager']
    } ->
    package { 'proxmox-ve-2.6.32':
        ensure => $package_versions['proxmox-ve-2.6.32']
    }

    if ($package_versions['ploop']) {
        package { 'ploop':
            ensure => $package_versions['ploop'],
            before => [ 
                Package['vzctl']
            ]
        }        
    }
    
    if($package_versions['pve-database']) {
        package { 'pve-database':
            ensure => $package_versions['pve-database'],
            before => [ 
                Package['qemu-server'],
                Package['pve-manager']
            ]
        }
    }
}
