# == Class: proxmox
#
# Manages Proxmox Virtual Environment
#
# === Authors
#
# Henry Spanka <henry@myvirtualserver.de>
#
# === Copyright
#
# Copyright 2015 Henry Spanka, unless otherwise noted.
#
class proxmox (
    $package_versions               = $proxmox::params::package_versions,
    $grub2_version                  = $proxmox::params::grub2_version,
    $kernel                         = $proxmox::params::kernel,
    $kernel_modules                 = $proxmox::params::kernel_modules,
    $install_kernel_headers         = $proxmox::params::install_kernel_headers,
    $auto_kernel_reboot             = $proxmox::params::auto_kernel_reboot,
    $repositories                   = $proxmox::params::repositories,
    $update_repositories            = $proxmox::params::update_repositories,
    $custom_certificates            = $proxmox::params::custom_certificates,
    $custom_bashrc                  = $proxmox::params::custom_bashrc,
    $interface_configuration        = $proxmox::params::interface_configuration,
    $route_configuration            = $proxmox::params::route_configuration,
    $source_routing_configuration   = $proxmox::params::source_routing_configuration,
    $source_ct_ip_interface         = $proxmox::params::source_ct_ip_interface
) inherits proxmox::params {
    
    $package_versions_merged = merge($package_versions, $proxmox::params::package_versions)
    validate_hash($package_versions_merged)
    if (is_string($grub2_version)) {
        validate_string($grub2_version)
    } else {
        validate_bool($grub2_version)
    }
    validate_hash($kernel)
    validate_hash($kernel_modules, $kernel_modules[openvz], $kernel_modules[kvm])
    validate_re($kernel[openvz], '^[\d]+\.[\d]+\.[\d]+\-[\d]+$')
    validate_re($kernel[kvm], '^[\d]+\.[\d]+\.[\d]+\-[\d]+$')
    validate_bool($install_kernel_headers)
    validate_bool($auto_kernel_reboot)
    validate_hash($repositories)
    validate_string($update_repositories)
    validate_re($update_repositories, '^always$|^daily$|^weekly$|^reluctantly$')
    if (is_string($custom_certificates)) {
        validate_re($custom_certificates, '^[A-Za-z0-9_-]+$')
    } else {
        validate_bool($custom_certificates)
    }
    validate_bool($custom_bashrc)
    validate_hash($interface_configuration)
    validate_hash($route_configuration)
    validate_hash($source_routing_configuration)
    if (is_string($source_ct_ip_interface)) {
        validate_string($source_ct_ip_interface)
    } else {
        validate_bool($source_ct_ip_interface)
    }
    
    if ($::osfamily != 'Debian') {
        fail('Only Debian 7(wheezy) supported')
    }
    
    class { '::proxmox::config':
      package_versions              => $package_versions_merged,
      grub2_version                 => $grub2_version,
      kernel                        => $kernel,
      kernel_modules                => $kernel_modules,
      install_kernel_headers        => $install_kernel_headers,
      auto_kernel_reboot            => $auto_kernel_reboot,
      repositories                  => $repositories,
      update_repositories           => $update_repositories,
      custom_certificates           => $custom_certificates,
      custom_bashrc                 => $custom_bashrc,
      interface_configuration       => $interface_configuration,
      route_configuration           => $route_configuration,
      source_routing_configuration  => $source_routing_configuration,
      source_ct_ip_interface        => $source_ct_ip_interface
    }
}
