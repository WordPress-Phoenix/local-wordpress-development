<?php
/*
Plugin Name: Remove Core REST Routes
Description: Removes the WP Core REST API routes added in 4.7
Version: 0.1
*/

// remove core WP API routes
remove_action( 'rest_api_init', 'create_initial_rest_routes', 99 );
