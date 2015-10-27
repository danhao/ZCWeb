class OwlCarouselController
	constructor: ($log, scope, element, attrs) ->
		@initCarousel = () ->
			$(element).owlCarousel(scope.owlOptions)

class OwlCarouselDirective
	constructor: ($log) ->
		return {
			restrict: 'EA'
			transclude: false
			scope:
				owlOptions: '='
			controller: ['$log', '$scope', '$element', '$attrs', OwlCarouselController]
		}


class OwlCarouselItemDirective
	constructor: ($log) ->
		link = (scope, element, attrs, controller) ->
			if scope.$last
				controller.initCarousel()
				
		return {
			restrict: 'A'
			require: '^owlCarousel'
			link: link
		}


angular.module('app')
	.directive 'owlCarousel', ['$log', OwlCarouselDirective]
	.directive 'owlCarouselItem', ['$log', OwlCarouselItemDirective]
	
