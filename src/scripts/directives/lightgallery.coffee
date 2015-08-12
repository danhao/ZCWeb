class Directive
	constructor: ($log, $window) ->

		selector = 'lb-img'
		# selector = 100+Math.round(Math.random()*10000).toString(16)
		
		getFileExt = (url) ->
			u1 = url.split("?")[0]
			u2s = u1.split(".")
			u2s[u2s.length-1].toLowerCase()

		imgExts =
			["jpg", "jpeg", "ico", "png", "bmp"]

		link = ($scope, element, attrs) ->
			rootSelector = attrs.rootSelector
			if rootSelector
				url = attrs.src
				if getFileExt(url) in imgExts
					element.addClass(selector)
				else
					element.on "click", () ->
						$window.open url
				
			if $scope.$last
				$el = element.parent()
				if rootSelector
					$el.lightGallery({selector: rootSelector+' .'+selector})
				else
					$el.lightGallery()

		return {
			restrict: 'A',
			link: link
		}
			


angular.module('app').directive 'lightgallery', ['$log', '$window', Directive]
