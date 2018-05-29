<?php
/*
Plugin Name: Restrict Media Upload Types
Description: Only allow specific media types for uploads.
Version: 0.2
Author: Seth Carstens
*/

/**
 * Only allow GIF, JPG, and PNG's
 *
 * @since 0.1
 *
 * @param $mimes
 *
 * @return array
 */
function restrict_mime( $mimes ) {
	$mimes = array(
		'gif'          => 'image/gif',
		'jpg|jpeg|jpe' => 'image/jpeg',
		'png'          => 'image/png',
	);

	return $mimes;
}

add_filter( 'upload_mimes', 'restrict_mime' );
