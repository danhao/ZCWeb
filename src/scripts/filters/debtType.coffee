class Filter
	constructor: (@$log) ->
		return (type) ->
			{"1": "债权代理", "2": "债权转让"}[type]


angular.module('app').filter 'debtType', ['$log', Filter]
