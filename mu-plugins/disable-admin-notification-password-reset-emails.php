<?php
/*
Plugin Name: Disable Admin Notification Password Reset Emails
Description: Stop sending annoying password was reset emails to webmaster email address.
Version: 1.0
Network: true
*/
if ( !function_exists( 'wp_password_change_notification' ) ) {
	function wp_password_change_notification() {}
}