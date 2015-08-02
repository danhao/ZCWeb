class Filter
	constructor: (@$log) ->
		return (type) ->
			{"1": "消费贷", "2": "信用卡", "3": "房贷", "10": "其它"}[type]


angular.module('app').filter 'debtProperty', ['$log', Filter]
