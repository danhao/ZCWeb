class Filter
	constructor: (@$log, @$sce) ->
		return (url) ->
			$sce.trustAsResourceUrl url


angular.module('app').filter 'trustUrl', ['$log', '$sce', Filter]
