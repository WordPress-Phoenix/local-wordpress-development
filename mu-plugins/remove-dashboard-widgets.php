<?php
/**
 * Plugin Name: Remove WordPress Dashboard Widgets
 */


// Remove Dashboard Metabox Widgets for all users except Admin
add_action( 'wp_dashboard_setup', 'custom_remove_dashboard_widgets', 9998 );
function custom_remove_dashboard_widgets() {
	global $wp_meta_boxes;
	unset( $wp_meta_boxes['dashboard'] );
}

/**
 * Build the custom dashboard widget
 */
add_action( 'wp_dashboard_setup', 'custom_add_dashboard_widget', 9999 );
function custom_add_dashboard_widget() {
	wp_add_dashboard_widget(
		'custom_dashboard_widget',
		'Hello!',
		'custom_dashboard_widget'
	);
}

function custom_dashboard_widget() {
	$links = [];

	ob_start();
	?>
	<p>
		<strong>Where'd everything go?</strong>
		The Dashboard modules have been disabled to improve login speed. Please use the left navigation to begin your adventure.
	</p>
	<ul style="list-style:none;">
		<?php
		foreach ( $links as $item ) {
			echo '<li><a href="' . esc_url( $item['url'] ) . '">';
			echo '<span class="dashicons ' . esc_attr( $item['class'] ) . '"></span> ';
			echo esc_attr( $item['name'] );
			echo '</a></li>';
		}
		?>
	</ul>
	<?php
	$message = ob_get_clean();
	echo '<div class="feature_post_class_wrap">';
	echo wp_kses( $message, wp_kses_allowed_html( 'post' ) );
	echo '</div>';
}
