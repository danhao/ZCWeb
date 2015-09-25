class Controller
	constructor: ($log) ->
		$log.log 'voip directive controller'


class Directive
	constructor: ($log) ->
		return {
			controller: ['$log', Controller]
			controllerAs: 'ctrl'
			replace: true
			restrict: 'E'
			scope: {}
			templateUrl: '/views/directives/voip.html'
			transclude: true
		}

angular.module('app').directive 'voip', ['$log', Directive]

