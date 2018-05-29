<?php
/*
Plugin Name: Remove Editor Menu Capabilities
Description: Removes the edit_theme_options editor role capability to restrict access to site's primary nav menu editor.
Version: 0.1
*/

add_filter( 'admin_init', function() {
	$role_object = get_role( 'editor' );
	if ( $role_object->has_cap( 'edit_theme_options' ) ) {
		$role_object->remove_cap( 'edit_theme_options' );
	}
});
