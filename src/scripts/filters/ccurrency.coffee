class Filter
	constructor: (@$log, @$filter) ->
		###
		return (value) ->
			value = value / 100 # 先将分转为元
			[value, flag] = [value / 10000, true] if Math.abs(value) > 10000
			#value = $filter('currency')(value, "￥")
			value = "￥"+value
			value + (if flag then "万" else "") + "元"
		###
		return (value) =>
			value = value / 100
			@$filter('currency')(value, "")
			

angular.module('app').filter 'ccurrency', ['$log', '$filter', Filter]
