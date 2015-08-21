class Filter
	constructor: (@$log, @handTypeService) ->
		return (time) ->
			diff = Math.abs(Date.now() - (time*1000))
			d = diff / (24*60*60*1000)
			d = Math.floor d
			t = handTypeService.getTypeByDay d
			t and t.text
			
angular.module('app').filter 'handType', ['$log', 'handTypeService', Filter]
