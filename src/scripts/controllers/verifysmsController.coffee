
class Controller
	constructor: (@$log, @$state) ->
		@$verify = () ->
			$state.go 'site.register3'


