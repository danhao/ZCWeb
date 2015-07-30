class Filter
	constructor: (@$log) ->
		return (type) ->
			{"1": "男", "2": "女"}[type]


angular.module('app').filter 'userSex', ['$log', Filter]
