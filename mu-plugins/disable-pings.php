<?php
/*
Plugin Name: Disable Pings
Description: Remove the do_pings action
Version: 0.1
Author: Seth Carstens
License: GPL
*/

/**
 * Disable pings by removing action
 *
 * *** Note, by removing do_all_pings action, we'll also not be
 * cleaning up the _pingme and _encloseme post meta, as that function
 * loops over items with that meta and tidies it itself. So if this
 * plugin gets disabled, the next time do_pings runs it'll find all of
 * those posts that have the _pingme or _encloseme meta set ¯\_(ツ)_/¯
 *
 * @since 0.1
 *
 * @return void
 */
function ml_disable_pings() {
	remove_action( 'do_pings', 'do_all_pings', 10 );
}

add_action( 'init', 'ml_disable_pings' );
