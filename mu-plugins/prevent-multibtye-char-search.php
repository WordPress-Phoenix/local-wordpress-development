<?php
/**
 * Plugin will prevent any searches on non-standard characters like chinese,mandarin, etc.
 */
if ( ! empty( $_GET['s'] ) ) {
	if ( ! mb_check_encoding( $_GET['s'], 'ASCII' ) && mb_check_encoding( $_GET['s'], 'UTF-8' ) ) {
		header( 'Location: ' . get_home_url(), true, 302 );
	}
}
