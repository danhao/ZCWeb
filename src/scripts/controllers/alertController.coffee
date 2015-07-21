class Controller
	constructor: (@$log, @messageService, @$timeout) ->
		@alerts =  []
		@messageService.subscribe 'alert', (name, parameters) =>
			@alerts.push parameters
			unless parameters.timeout and parameters.timeout is -1
				$timeout ()=>
					@closeAlert @alerts.length-1
				, parameters.timeout || 2*1000

	closeAlert: (index) ->
		@alerts.splice index, 1

angular.module('app').controller 'alertController', ['$log', 'messageService', '$timeout', Controller]
