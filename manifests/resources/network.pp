define proxmox::resources::network::add_source_route(
    $ipaddress,
    $netmask,
    $gateway,
    $table,
    $type = 'route',
    $ensure = 'present'
) {
    
    validate_array($ipaddress)
    validate_array($netmask)
    validate_array($gateway)
    validate_array($table)
    validate_array($type)
    
    $interface = $name
    
    file { "source-routeup-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-up.d/z100-source-route-${interface}",
        content => template('proxmox/network/source_route_up-Debian.erb'),
        notify  => $::network::manage_config_file_notify
    }
    file { "source-routedown-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-down.d/z100-source-route-${interface}",
        content => template('proxmox/network/source_route_down-Debian.erb'),
        notify  => $::network::manage_config_file_notify
    }
}

define proxmox::resources::network::add_neighbor(
    $ipaddress,
    $macaddress,
    $type = 'ip',
    $ensure = 'present'
) {
    
    validate_array($ipaddress)
    validate_array($macaddress)
    validate_array($type)
    
    $interface = $name
    
    file { "permanent_neighborsup-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-up.d/z95-permanent-neighbors-${interface}",
        content => template('proxmox/network/permanent_neighbors_up-Debian.erb'),
        notify  => $::network::manage_config_file_notify
    }
    file { "permanent_neighborsdown-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-down.d/z95-permanent-neighbors-${interface}",
        content => template('proxmox/network/permanent_neighbors_down-Debian.erb'),
        notify  => $::network::manage_config_file_notify
    }
}

class proxmox::resources::network {
    
    if ( !empty($::proxmox::config::interface_configuration) ) or ( !empty($::proxmox::config::route_configuration) ) {
        class { '::network':
            interfaces_hash => $::proxmox::config::interface_configuration,
            routes_hash => $::proxmox::config::route_configuration
        }
    }
    if ( !empty($::proxmox::config::source_routing_configuration) ) {
        create_resources(proxmox::resources::network::add_source_route, $::proxmox::config::source_routing_configuration)
    }
    if ( !empty($::proxmox::config::neighbors_configuration) ) {
        create_resources(proxmox::resources::network::add_neighbor, $::proxmox::config::neighbors_configuration)
    }    
    
}
