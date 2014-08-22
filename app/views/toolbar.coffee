module.exports = class ToolbarView extends Backbone.View
	template: require 'views/templates/toolbar'
	idName: 'toolbar'
	events:
		'click #build .resource-view': 'resourceViewClicked'

	render: =>
		@$el.attr('id', @idName).html(@template())
		
	renderScore: (score) =>
		trend = switch score.trend
			when 3 then '⬆'
			when 2 then '⬈'
			when -2 then '⬊'
			when -3 then '⬇'
			else '–'
				
		if score.countdown > 0
			line1 = 'Hold for'
			line2 = Math.round score.countdown
		else
			line1 = score.score + '%'
			line2 = trend

		@$('.progress text')[0].innerHTML = line1
		@$('.progress text')[1].innerHTML = line2

	resourceViewClicked: (event) =>
		event.preventDefault()
		@trigger 'toggle-resource-view'
