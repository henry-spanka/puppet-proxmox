class proxmox::profile::kvm::configuration {
    
    create_resources(proxmox::resources::kernel::kernel_module, $::proxmox::config::kernel_modules[kvm])
    
    sysctl { 'net.bridge.bridge-nf-call-ip6tables':
        value => '0'
    } ->
    sysctl { 'net.bridge.bridge-nf-call-iptables':
        value => '0'
    } ->
    sysctl { 'net.bridge.bridge-nf-call-arptables':
        value => '0'
    } ->
    sysctl { 'net.bridge.bridge-nf-filter-vlan-tagged':
        value => '0'
    }
}