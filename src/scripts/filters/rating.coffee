class Filter
	constructor: (@$log, @utilService) ->
		# return (score) =>
		# 	utilService.rating score
		return @utilService.rating


angular.module('app').filter 'rating', ['$log', 'utilService', Filter]
