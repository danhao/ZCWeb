class Filter
	constructor: (@$log, @constant) ->
		return (type) ->
			c = _.find constant.contactType, (t) -> t.value == type
			if c then c.name else ''


angular.module('app').filter 'contactType', ['$log', 'constant', Filter]
