class Filter
	constructor: (@$log, @$filter) ->
		return (value, format) ->
			unless value
				return ''
			d = new Date()
			d.setTime(value * 1000)
			$filter('date')(d, format || 'yyyy-MM-dd')

angular.module('app').filter 'idate', ['$log', '$filter', Filter]
