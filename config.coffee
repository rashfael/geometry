#
# Brunch configuration file. For documentation see:
# 	https://github.com/brunch/brunch/blob/stable/docs/config.md
#
exports.config =
	paths:
		watched: [
			'app'
		]
	files:
		javascripts:
			joinTo:
				'js/vendor.js': /^app[\\/]vendor/
				'js/app.js': /^app[\\/](?!vendor)/
			order:
				before: [
					'app/vendor/js/jquery.js'
					'app/vendor/js/underscore.js'
					'app/vendor/js/backbone.js'
					'app/vendor/js/bootstrap.js'
				]
		stylesheets:
			joinTo:
				'css/app.css': /^app/
			order:
				before: [
					'app/vendor/css/bootstrap.css'
				]
		templates:
			joinTo: 'js/app.js'
	plugins:
		static_jade:
			extension: ".static.jade"
	server:
		port: 9000
		