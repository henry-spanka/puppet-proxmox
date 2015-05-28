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
    
    create_resources(proxmox::resources::repo::create, $::proxmox::config::repositories)
}
