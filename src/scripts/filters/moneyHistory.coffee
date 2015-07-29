class Filter
	constructor: (@$log) ->
		return (state) ->
			{"0": "失败", "1": "成功"}[state]

angular.module('app').filter 'moneyHistoryState', ['$log', Filter]


class Filter
	constructor: (@$log) ->
		return (type) ->
			{"0":"系统","1": "充值", "2": "结单", "3": "保证金返回", "4": "提现", "5": "支付保证金","6": "购买VIP服务"}[type]

angular.module('app').filter 'moneyHistoryType', ['$log', Filter]

