
class StatController
	constructor: (@$log, @$scope, @ajaxService, @actionCode) ->
		@$scope.options =
			trackColor: 'rgba(255,255,255,0.2)',
			scaleColor: 'rgba(255,255,255,0.5)',
			barColor: 'rgba(255,255,255,0.7)',
			lineWidth: 7,
			lineCap: 'butt',
			size: 148
		# init
		now = moment()
		@q =
			timeTo: now.format "YYYY/MM/DD"
			timeFrom: now.startOf("month").format "YYYY/MM/DD"
			state: 3
		@stat(@q)
		
		@$scope.$watch () => @q
		,
		(newVal, oldVal) =>
			if newVal isnt oldVal
				@stat(@q)
		, true

	stat: (q) ->
		param =
			state: q.state			# 已成交
			receiveTimeFrom: moment(new Date(q.timeFrom)).unix()
			receiveTimeTo: moment(new Date(q.timeTo)).unix()
		@ajaxService.post @actionCode.ACTION_STAT, param
			.success (ret) =>
				# @$log.log ret
				@statRet = ret
				@statRet.rateOfReturnMoney = if ret.money is 0 then 0 else Math.round(ret.repayment / ret.money * 100)
				@statRet.rateOfComplete = if ret.total is 0 then 0 else Math.round(ret.done / ret.total * 100)
			.error (err) =>
				@$log.log err


angular.module('app').controller 'statController', ['$log', '$scope', 'ajaxService', 'actionCode', StatController]
