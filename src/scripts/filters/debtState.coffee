class Filter
	constructor: (@$log) ->
		return (state) ->
			{"0": "未审核", "1": "已通过", "2": "未通过", "3": "已成交", "4": "已完成"}[state]


angular.module('app').filter 'debtState', ['$log', Filter]
