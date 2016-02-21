class proxmox::params {
    $package_versions               = {
        'pve-firmware' => '1.1-4',
        'corosync-pve' => '1.4.7-1',
        'glusterfs-client' => '3.5.2-1',
        'ksm-control-daemon' => '1.1-1',
        'pve-libspice-server1' => '0.12.4-3',
        'openais-pve' => '1.1.4-3',
        'libpve-common-perl' => '3.0-24',
        'pve-cluster' => '3.0-17',
        'redhat-cluster-pve' => '3.2.0-2',
        'fence-agents-pve' => '4.0.10-2',
        'resource-agents-pve' => '3.9.2-4',
        'libpve-access-control' => '3.0-16',
        'libpve-storage-perl' => '3.0-33',
	'pve-firewall' => '1.0-21',
        'pve-qemu-kvm' => '2.2-10',
        'vzquota' => '3.1-2',
        'vzprocps' => '2.0.11-2',
        'vzctl' => '4.0-1pve6',
        'vncterm' => '1.1-8',
        'novnc-pve' => '0.4-7',
        'qemu-server' => '3.4-6',
        'pve-manager' => '3.4-6',
        'proxmox-ve-2.6.32' => '3.4-156'
    }
    $grub2_version                  = false #2.x Version currently breaks auto reboot script e.g. '2.02~bpo70+6'
    $kernel                         = {
        'openvz' => '2.6.32-39',
        'kvm' => '3.10.0-10'
    }
    $kernel_modules                 = {
        'openvz' => {
            'tun' => {
                ensure => present
            }
        },
        'kvm' => {
	    'nf_conntrack_proto_gre' => {
		ensure => present
	    }
	}
    }
    $install_kernel_headers         = true
    $auto_kernel_reboot             = true
    $repositories                   = {
        'proxmox-no-subscription' => {
            comment => 'Official Proxmox Repository',
            location => 'http://download.proxmox.com/debian/',
            release => 'wheezy',
            repos => 'pve-no-subscription',
            key => {
                'id' => 'BE257BAA5D406D01157D323EC23AC7F49887F95A',
                'server' => 'keyserver.ubuntu.com'
            }
        }
    }
    $update_repositories            = 'daily'
    $custom_certificates            = false
    $custom_bashrc                  = true
    $interface_configuration        = {
        'lo' => {
            method => 'loopback',
            address => false,
            manage_order => 1
        },
        'lo:0' => {
            method => 'loopback',
            address => false,
            family => 'inet6',
            manage_order => 2
        },
        'eth0' => {
            method => 'manual',
            address => false,
            manage_order => 3
        },
        'eth1' => {
            method => 'manual',
            address => false,
            manage_order => 4
        },
        'vmbr0' => {
            ipaddress => $::ipaddress,
            netmask => $::netmask,
            gateway => '192.168.88.1', # for example. Cannot be retrieved via puppet facts
            bridge_ports => ['eth0'],
            bridge_stp => false,
            bridge_fd => 0,
            manage_order => 5
        },
        /*'vmbr1' => {
            ipaddress => '10.10.10.7',
            netmask => '255.255.255.0',
            bridge_ports => ['eth1'],
            bridge_stp => false,
            bridge_fd => 0,
            manage_order => 6
        }*/
    }
    $route_configuration            = {}
    $source_routing_configuration   = {
        /*'vmbr1' => {
            ipaddress => ['37.228.135.128'],
            netmask => ['255.255.255.224'],
            gateway => ['10.10.10.1'],
            table => [10000],
            type => 'route'
        }*/
    }
    $neighbors_configuration		= {}
    $source_ct_ip_interface         = '' # for example vmbr1
    $neighbour_devs                 = {
        mode => 'detect'
    } # for example {mode: list ['vmbr1']}
    $backup_configuration           = {}
    $ssh_manage                     = true
    $ssh_client_options             = {}
    $ssh_server_options             = {}
    $ssh_storeconfigs_enabled       = true
    $ssh_version                    = 'latest'
}
