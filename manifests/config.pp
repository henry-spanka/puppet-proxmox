# private global parameters class. Do not use directly!
class proxmox::config (
	$package_versions 				= {},
	$grub2_version					= undef,
	$kernel 						= {},
	$kernel_modules					= {},
	$install_kernel_headers 		= undef,
	$auto_kernel_reboot 			= undef,
	$repositories 					= {},
	$update_repositories			= undef,
	$custom_certificates			= undef,
	$custom_bashrc					= undef,
	$interface_configuration		= {},
	$route_configuration			= {},
	$source_routing_configuration	= {},
	$source_ct_ip_interface			= undef
) {
}