class Filter
	constructor: (@$log) ->
		return (state) ->
			{"0": "处理中", "1": "已处理"}[state]


angular.module('app').filter 'fileState', ['$log', Filter]
