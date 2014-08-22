#
# Application entry point.
#
HomeView = require 'views/home'
StageView = require 'views/stage'

class Application
	constructor: ->
		if /nologo$/.test window.location.pathname
			@stage()
		else
			@home()

	home: =>
		view = new HomeView()
		view.render()
		$('.container').empty().append view.$el
		view.on 'start', @stage

	stage: =>
		view = new StageView()
		view.render()
		$('.container').empty().append view.$el
		
$ ->
	new Application()
