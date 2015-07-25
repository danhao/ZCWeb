class Directive
	constructor: ($log) ->

		link = (scope, element, attrs) ->
			if scope.$last
				element.parent().lightGallery()

		return {
			restrict: 'A',
			link: link
		}
			


angular.module('app').directive 'lightgallery', ['$log', Directive]
