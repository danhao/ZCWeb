
class StatController
	constructor: (@$log, @$scope, @ajaxService, @actionCode) ->
		@$scope.percent1 = 65
		@$scope.percent2 = 35
		@$scope.percent3 = 80
		@$scope.percent4 = 99
		@$scope.options =
			trackColor: 'rgba(255,255,255,0.2)',
			scaleColor: 'rgba(255,255,255,0.5)',
			barColor: 'rgba(255,255,255,0.7)',
			lineWidth: 7,
			lineCap: 'butt',
			size: 148



angular.module('app').controller 'statController', ['$log', '$scope', 'ajaxService', 'actionCode', StatController]
