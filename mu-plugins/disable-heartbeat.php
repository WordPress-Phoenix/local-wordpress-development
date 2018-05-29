<?php
/**
 * Plugin Name: Reaper
 * Description: Death to Heartbeat
 * Version: 1.1
 * Author: Seth Carstens
 *
 * @author Seth Carstens
 * @package wp_reaper
 */

namespace Reaper;

/**
 * Add action to admin init as proper scope time to remove an admin script,
 */
add_action( 'admin_init', 'Reaper\\stop_heartbeat', 1 );

/**
 * Un-register the heartbeat javascript library so it never runs.
 */
function stop_heartbeat() {
	wp_deregister_script( 'heartbeat' );
}
