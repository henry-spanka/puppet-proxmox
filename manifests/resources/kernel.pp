define proxmox::resource::kernel::bootKernel (
    $action = $title,
    $kernel
) {
    
    if($action == 'changekernel') {
        file { '/var/tmp/changekernel.bash':
            ensure => 'present',
            source => 'puppet:///modules/proxmox/kernel/changekernel.bash',
            mode => '755',
        } ~>
        exec { "/bin/bash /var/tmp/changekernel.bash ${kernel}":
            refreshonly => true
        }
    } else {
        file { '/var/tmp/changekernel.bash':
            ensure => 'absent'
        }
    }
}

# Copied from http://projects.puppetlabs.com/projects/1/wiki/Kernel_Modules_Patterns
define proxmox::resources::kernel::kernel_module ($ensure) {
    $modulesfile = $operatingsystem ? { debian => "/etc/modules", redhat => "/etc/rc.modules", centos=>"/etc/rc.modules" }
    case $operatingsystem {
        redhat: { file { "/etc/rc.modules": ensure => file, mode => 755 } }
        centos: { file { "/etc/rc.modules": ensure => file, mode => 755 } }
    }
    case $ensure {
        present: {
            exec { "insert_module_${name}":
                command => $operatingsystem ? {
                    debian => "/bin/echo '${name}' >> '${modulesfile}'",
                    redhat => "/bin/echo '/sbin/modprobe ${name}' >> '${modulesfile}' ",
                    centos => "/bin/echo '/sbin/modprobe ${name}' >> '${modulesfile}' "
                },
                unless => $operatingsystem ? {
                    debian => "/bin/grep -qFx '${name}' '${modulesfile}'",
                    redhat => "/bin/grep -q '^/sbin/modprobe ${name}\$' '${modulesfile}'",
                    centos => "/bin/grep -q '^/sbin/modprobe ${name}\$' '${modulesfile}'",
                }
            }
            exec { "/sbin/modprobe ${name}": unless => "/bin/grep -q '^${name} ' '/proc/modules'" }
        }
        absent: {
            exec { "/sbin/modprobe -r ${name}": onlyif => "/bin/grep -q '^${name} ' '/proc/modules'" }
            exec { "remove_module_${name}":
                command => $operatingsystem ? {
                    debian => "/usr/bin/perl -ni -e 'print unless /^\\Q${name}\\E\$/' '${modulesfile}'",
                    redhat => "/usr/bin/perl -ni -e 'print unless /^\\Q/sbin/modprobe ${name}\\E\$/' '${modulesfile}'",
                    centos => "/usr/bin/perl -ni -e 'print unless /^\\Q/sbin/modprobe ${name}\\E\$/' '${modulesfile}'"
                },
                onlyif => $operatingsystem ? {
                    debian => "/bin/grep -qFx '${name}' '${modulesfile}'",
                    redhat => "/bin/grep -q '^/sbin/modprobe ${name}\$' '${modulesfile}'",
                    centos => "/bin/grep -q '^/sbin/modprobe ${name}\$' '${modulesfile}'"
                }
            }
        }
        default: { err ( "unknown ensure value ${ensure}" ) }
    }
}

class proxmox::resources::kernel(
    $kernel = $::proxmox::config::kernel[openvz]
) {
    
    package { "pve-kernel-${kernel}-pve":
        ensure => installed,
        require => Exec['apt_update']
    } ->
    package { "pve-headers-${kernel}-pve":
        ensure => $::proxmox::config::install_kernel_headers ? {
            true => 'installed',
            default =>'absent'
        }
    }
    
    if($kernelrelease == "${kernel}-pve") {
        proxmox::resource::kernel::bootKernel { 'alreadybooted':
            kernel => "${kernel}-pve"
        }
    } else {
        proxmox::resource::kernel::bootKernel { 'changekernel':
            kernel => "${kernel}-pve",
            require => Package["pve-kernel-${kernel}-pve"]
        }
        if($::proxmox::config::auto_kernel_reboot) and ($kernelrelease !~ /-pve$/) {
            exec { "/sbin/shutdown -r +5 System is rebooting because we are loading a new kernel ${kernel}-pve as requested via puppet &":
                require => proxmox::resource::kernel::bootKernel['changekernel']
            }
        }
    }
}