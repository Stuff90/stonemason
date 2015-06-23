<html>
	<head>
	    <link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/style.css">

	    <!-- =======================================
			Check if the website is running locally
			If yes, import the livereload library
		======================================== -->
		<?php if (in_array($_SERVER['REMOTE_ADDR'], array('127.0.0.1', '::1'))) { ?>
			<script src="//localhost:35729/livereload.js"></script>
		<? } ?>
		<!-- =================================== -->
	</head>
<body>