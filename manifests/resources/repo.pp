#
# Sets up the package repos necessary to use Proxmox
# on Debian
#
define proxmox::resources::repo::create(
    $comment,
    $location,
    $release,
    $repos,
    $key
) {
    
    apt::source { $title:
      comment  => $comment,
      location => $location,
      release  => $release,
      repos    => $repos,
      key      => $key
    }
}

class proxmox::resources::repo {
    
    class { 'apt':
        update => {
            frequency => $::proxmox::config::update_repositories
        },
    }
    
    file { 'repo-pve-enterprise.list':
        ensure => absent,
        path => '/etc/apt/sources.list.d/pve-enterprise.list',
        before => Exec['apt_update'],
        notify => Exec['apt_update']
    }
    
    create_resources(proxmox::resources::repo::create, $::proxmox::config::repositories)
}
