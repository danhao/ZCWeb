class Filter
	constructor: (@$log, @const) ->
		return (type) ->
			_.find @const.contactType, (t) -> t.value == type


angular.module('app').filter 'contactType', ['$log', 'const']
