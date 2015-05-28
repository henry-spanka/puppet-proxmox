class proxmox::resources::hosts {
    host { 'localhost.localdomain':
        ip => '127.0.0.1',
            host_aliases => [ 'localhost' ],
    }
    host { $::fqdn:
        ip => $::ipaddress,
            host_aliases => [ $::hostname ],
    }
}