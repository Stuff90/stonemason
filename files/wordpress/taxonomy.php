<?php
	$taxonomyTemplate = locate_template('templates/taxonomies/'. $taxonomy .'.php');
	if (file_exists($taxonomyTemplate)) {
		require_once($taxonomyTemplate);
	} else {
		header('Location: /404.php');
	}
?>