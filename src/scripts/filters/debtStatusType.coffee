class Filter
	constructor: (@$log, @constant) ->
		return (type) ->
			_.find constant.debtStatusType, (item) ->
				item.value is type
			.name


angular.module('app').filter "debtStatusType", ['$log', 'constant', Filter]
