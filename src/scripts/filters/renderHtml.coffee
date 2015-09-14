class Filter
	constructor: (@$log, @$sce) ->
		return (html) =>
			@$sce.trustAsHtml html


angular.module('app').filter 'renderHtml', ['$log', '$sce', Filter]
