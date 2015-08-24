class Filter
	constructor: (@$log, @utilService) ->
		return (time) =>
			###
			diff = Math.abs(Date.now() - (time*1000))
			d = diff / (24*60*60*1000)
			d = Math.floor d
			t = handTypeService.getTypeByDay d
			t and t.text
			###
			t = @utilService.getHandTypeByTime time
			t and t.text
			
angular.module('app').filter 'handType', ['$log', 'utilService', Filter]
