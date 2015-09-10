class Controller
	constructor: (@$log,@$scope, @$filter, @actionCode, @ajaxService, @userSession,@$state, @$stateParams, @utilService, @growlService) ->
		initindex = () =>
			@pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: @pid}
				.success (result) =>
					$scope.email=result.email
					$scope.isverifyemail =  (result.status&1)==1
					$scope.isverifymobile=  (result.status&2)==2
					if result.type==0
						$scope.isverifyinfo = (result.status&4)==4
					else
						$scope.isverifyinfo = (result.status&8)==8
					@user = result
					# @$log.log @user
					
				.error (error) =>
					growlService.growl(error.desc, 'danger')
		initindex()

		situationlist = () =>
			@ajaxService.post @actionCode.ACTION_LIST_SITUAION, null
			.success (rets) ->
				$scope.situationlist = rets.situation
			.error (error) ->
				growlService.growl(error.desc, 'danger')

		situationlist()

		@$scope.options =
			trackColor: 'rgba(255,255,255,0.2)'
			scaleColor: 'rgba(255,255,255,0.5)'
			barColor: 'rgba(255,255,255,0.7)'
			lineWidth: 7
			lineCap: 'butt'
			size: 148

		# 统计
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
				# @$log.log ret
				@$scope.rateOfReturnMoney = if ret.money is 0 then 0 else Math.round(ret.repayment / ret.money * 100)
				@$scope.rateOfComplete = if ret.total is 0 then 0 else Math.round(ret.done / ret.total * 100)
			.error (err) =>
				@$log.log err
			

angular.module('app').controller 'memberIndexController', ['$log','$scope', '$filter', 'actionCode', 'ajaxService', 'userSession','$state','$stateParams', 'utilService', 'growlService', Controller]
