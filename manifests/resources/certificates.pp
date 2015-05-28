# Manage Proxmox SSL Certificates
class proxmox::resources::certificates {
    
    if($::proxmox::config::custom_certificates) {
        
        $custom_certificate = $::proxmox::config::custom_certificates
    
        file { '/root/ssl':
            ensure => directory,
        } ->
        file { '/root/ssl/pve-root-ca.pem':
            ensure => file,
            owner => root,
            group => www-data,
            mode => 640,
            source => "puppet:///modules/proxmox/ssl/pve-root-ca-${custom_certificate}.pem",
        } ->
        file { '/root/ssl/pve-ssl.key':
            ensure => file,
            owner => root,
            group => www-data,
            mode => 640,
            source => "puppet:///modules/proxmox/ssl/pve-ssl-${custom_certificate}.key",
        } ->
        file { '/root/ssl/pve-ssl.pem':
            ensure => file,
            owner => root,
            group => www-data,
            mode => 640,
            source => "puppet:///modules/proxmox/ssl/pve-ssl-${custom_certificate}.pem",
        }
        
        if ($::proxmox::config::package_versions['pve-database']) {
            $notify_services = [
                Service['pveproxy'],
                Service['pvedaemon'],
                Service['spiceproxy'],
                Service['novncproxy']
            ]
        } else {
            $notify_services = [
                Service['pveproxy'],
                Service['pvedaemon'],
                Service['spiceproxy']
            ]           
        }
    
        exec { '/bin/cp /root/ssl/pve-root-ca.pem /etc/pve/pve-root-ca.pem && /bin/cp /root/ssl/pve-ssl.key /etc/pve/local/pve-ssl.key && /bin/cp /root/ssl/pve-ssl.pem /etc/pve/local/pve-ssl.pem':
            subscribe => [ 
                File['/root/ssl/pve-root-ca.pem'],
                File['/root/ssl/pve-ssl.key'],
                File['/root/ssl/pve-ssl.pem']
            ],
            notify => $notify_services,
            refreshonly => true
        }
    }
}