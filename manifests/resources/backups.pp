define proxmox::resources::backups::backup_job(
    $host,
    $port,
    $sourcedir,
    $targetdir,
    $username,
    $keyfile,
    $cron_date,
    $ensure = 'present'
) {
    
    validate_string($host)
    validate_integer($port)
    validate_string($sourcedir)
    validate_string($targetdir)
    validate_string($username)
    validate_string($keyfile)
    validate_string($ensure)
    validate_string($cron_date)
    validate_re($ensure, '^present$|^absent$')
    
    file { "proxmox-backup-cron-${name}":
        ensure  => $ensure,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        path    => "/etc/cron.d/proxmox-backup-cron-${name}",
        content => template('proxmox/backups/cron.erb')
    }
}

class proxmox::resources::backups {
      
    if ( !empty($::proxmox::config::backup_configuration) ) {
        create_resources(proxmox::resources::backups::backup_job, $::proxmox::config::backup_configuration)
    }
}
