
class StatController
	constructor: (@$log, @$scope, @ajaxService, @actionCode) ->
		@$scope.options =
			trackColor: 'rgba(255,255,255,0.2)',
			scaleColor: 'rgba(255,255,255,0.5)',
			barColor: 'rgba(255,255,255,0.7)',
			lineWidth: 7,
			lineCap: 'butt',
			size: 148
			
		@stat()
		

	stat: () ->
		now = moment()
		oneMonthAgo = now.subtract 30, 'days'
		param =
			state: 3			# 已成交
			receiveTimeFrom: oneMonthAgo.unix()
			receiveTimeTo: now.unix()
		@ajaxService.post @actionCode.ACTION_STAT, param
			.success (ret) =>
				@$log.log ret
				@statRet = ret
				@statRet.rateOfReturnMoney = if ret.money is 0 then 0 else Math.round(ret.repayment / ret.money * 100)
				@statRet.rateOfComplete = if ret.total is 0 then 0 else Math.round(ret.done / ret.total * 100)
			.error (err) =>
				@$log.log err


angular.module('app').controller 'statController', ['$log', '$scope', 'ajaxService', 'actionCode', StatController]
