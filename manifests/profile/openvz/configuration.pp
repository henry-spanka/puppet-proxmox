class proxmox::profile::openvz::configuration {
    
    $source_ct_ip_interface = $::proxmox::config::source_ct_ip_interface
    $neighbour_devs = $::proxmox::config::neighbour_devs
    
    file { '/etc/vz':
        ensure => directory,
        owner => root,
        group => root,
        mode => 755
    } ->
    file { '/etc/vz/vz.conf':
        ensure => present,
        content => template('proxmox/openvz/configuration/vz.erb'),
        owner => root,
        group => root,
        mode => 644
    } ->
    file { '/etc/vzdump.conf':
        ensure => present,
        source => 'puppet:///modules/proxmox/openvz/configuration/vzdump.conf',
        owner => root,
        group => root,
        mode => 644
    }
    
    create_resources(proxmox::resources::kernel::kernel_module, $::proxmox::config::kernel_modules[openvz])
    
    sysctl { 'net.ipv4.ip_forward':
        value => '1'
    } ->
    sysctl { 'net.netfilter.nf_conntrack_max':
        value => '2000000'
    } ->
    sysctl { 'net.ipv4.conf.default.forwarding':
        value => '1'
    } ->
    sysctl { 'net.ipv4.conf.default.proxy_arp':
        value => '0'
    } ->
    sysctl { 'net.ipv4.conf.all.rp_filter':
        value => '2'
    } ->
    sysctl { 'net.ipv4.conf.default.send_redirects':
        value => '1'
    } ->
    sysctl { 'net.ipv4.conf.all.send_redirects':
        value => '0'
    } ->
    sysctl { 'net.ipv6.conf.all.proxy_ndp':
        value => '1'
    } ->
    sysctl { 'net.ipv6.conf.all.forwarding':
        value => '1'
    } ->
    sysctl { 'net.netfilter.nf_conntrack_tcp_timeout_time_wait':
        value => '30'
    } ->
    exec { "/bin/echo 262144 > /proc/sys/fs/aio-max-nr":
        unless => "/bin/cat /proc/sys/fs/aio-max-nr | grep 262144"
    }
}