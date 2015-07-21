class Filter
	constructor: (@$log) ->
		return (type) ->
			{"1": "P2P公司", "2": "小贷公司", "3": "消费金融公司", "4": "专业催收公司", "5": "律师事务所"}[type]


angular.module('app').filter 'companyType', ['$log', Filter]
