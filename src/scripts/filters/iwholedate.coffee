class Filter
	constructor: (@$log, @$filter) ->
		return (value, format) ->
			d = new Date()
			d.setTime(value * 1000)
			$filter('date')(d, format || 'yyyy-MM-dd hh:mm:ss')

angular.module('app').filter 'iwholedate', ['$log', '$filter', Filter]