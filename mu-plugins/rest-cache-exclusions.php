<?php
/*
Plugin Name: REST Cache Exclusions
Description: Works together as a companion to the wp-rest-cache plugin. https://github.com/WordPress-Phoenix/wordpress-rest-cache
Version: 0.1
*/
$default_exclusions = 'api.github.com,downloads.wordpress.org,api.wordpress.org,delivery.gettyimages.com,thumb.usatodaysportsimages.com,winteriscoming.net';
define( 'WP_REST_CACHE_EXCLUSIONS', $default_exclusions );

// Revert the WP REST Cache plugin to only cache 200 responses (in a newer release, with this filter set to false, it'll cache/update ALL responses) -- MLT 3/22/17
add_filter( 'wrc_only_cache_200', '__return_true' );

/**
 * Add debug logging to see when the rest cache crons are being re-scheduled
 * -- MLT, 7/15/06
 */
function add_wrc_cron_log( $primary_blog, $current_blog ) {
	$msg = date( 'Y-m-d H:i:s' ) . ' Add cron - ' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . ' for blog ' . $primary_blog . '/' . $current_blog;
	file_put_contents( '/tmp/debug.log', $msg, FILE_APPEND );
}

//add_action( 'wrc_after_schedule_cron', 'add_wrc_cron_log', 10, 2 );

function didnt_add_wrc_cron( $primary_blog, $current_blog ) {
	$msg = date( 'Y-m-d H:i:s' ) . ' Did Not add cron - ' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . ' for blog ' . $primary_blog . '/' . $current_blog;
	file_put_contents( '/tmp/debug.log', $msg, FILE_APPEND );
}

//add_action( 'wrc_didnt_schedule_cron', 'didnt_add_wrc_cron', 10, 2 );
