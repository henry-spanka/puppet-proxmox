define proxmox::resources::network::add_source_route(
    $ipaddress,
    $netmask,
    $gateway,
    $table,
    $ensure = 'present'
) {
    
    validate_array($ipaddress)
    validate_array($netmask)
    validate_array($gateway)
    validate_array($table)
    
    $interface = $name
    
    file { "source-routeup-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-up.d/z100-source-route-${interface}",
        content => template('proxmox/network/source_route_up-Debian.erb'),
        notify  => $network::manage_config_file_notify,
    }
    file { "source-routedown-${interface}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/network/if-down.d/z100-source-route-${interface}",
        content => template('proxmox/network/source_route_down-Debian.erb'),
        notify  => $::network::manage_config_file_notify,
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
    
}