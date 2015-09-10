class Filter
	constructor: (@$log, @constant) ->
		return (state) ->
			# {"0": "未审核", "1": "已通过", "2": "未通过", "3": "已成交", "4": "已完成"}[state]
			debtState = constant.debtState
			st = {}
			st[debtState.TO_CHECK] = "未审核"
			st[debtState.CHECKING] = "审核中"
			st[debtState.CHECKED_PASS] = "已通过"
			st[debtState.CHECKED_FAILED] = "未通过"
			st[debtState.DEAL] = "已成交"
			st[debtState.COMPLETED] = "已完成"
			st[state]


angular.module('app').filter 'debtState', ['$log', 'constant', Filter]
