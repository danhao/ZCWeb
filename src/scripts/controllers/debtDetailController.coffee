
class DebtDetailController

	# 状态
	DEBT_STATE =
		ALL				: -1
		TO_CHECK		: 0
		CHECKED_PASS	: 1
		CHECKED_FAILED	: 2
		DEAL			: 3
		COMPLETED		: 4

	# 类型
	DEBT_TYPE =
		AGENT:  1
		ASSIGN: 2
		
	
	constructor: (@$log, @$state, @$stateParams, @$scope, @$timeout, @ajaxService, @actionCode, @userSession, @growlService) ->
		@getDebtDetail()
		@pid = @userSession.pid()
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@user = result
			.error (error) ->
				@$log.log error
				
		@rating=3
		@collectionTypes = [
			{value: 1, name: '电催'},
			{value: 2, name: '外访'},
			{value: 3, name: '信函'},
			{value: 4, name: '搜索'},
			{value: 5, name: '其他'}
		]

		@init_calendar()
		


	init_calendar: ->
		@$scope.datePicker = {opened: false}
		@$scope.open_calendar = ($event) =>
			$event.preventDefault()
			$event.stopPropagation()
			@$scope.datePicker.opened = true

	init_dialog: ->
		# 保证金: 10%, 500封顶
		@$scope.deposit = Math.min(Math.round(@debt.money * 0.1), 500*100)
		@$scope.debtType = @debt.type
		
		# 代理, 费率
		@$scope.agentLegalCheck = (price) =>
			if @debt.type == 1	# 费率
				10 <= price <= 100
			else
				true

		# 转让, 竞价
		@$scope.assignLegalCheck = (price) =>
			if @debt.type == 2
				if @debt.bidders and @debt.bidders.length > 0
					highest = _.max @debt.bidders, (bidder) -> bidder.money
					p = highest.money + @debt.bidIncrease
				else
					p = @debt.price + @debt.bidIncrease
				price*100 >= p
			else
				true

		@$scope.bidPrice = (price) =>
			if @$scope.bidForm.$valid
				price = parseInt(@$scope.price)
				data = if @debt.type == 1 then {"rate": price} else {"money": price * 100}
				data['id'] = @debt.id
				@ajaxService.post @actionCode.ACTION_BID, data
					.success (ret) =>
						# @$log.log ret
						@getDebtDetail()
						# reset form
						@$scope.price = ""
						@$scope.bidForm.$setPristine()
						@$scope.$broadcast 'show-errors-reset'
					
						angular.element "#bidModal"
							.modal "hide"
					.error (error) =>
						@$log.log error
						# alert error.desc
						@growlService.growl error.desc, 'warning'



	init_page_var: ->
		@$scope.expireDay = @debt.publishTime*1000 + @debt.expireDays*24*60*60*1000
		@bidderIds = _.map @debt.bidders, (bidder)-> bidder.id
		isBidded = @debt.type is DEBT_TYPE.AGENT and @pid in @bidderIds # 是否已投票
		
		@$scope.showBidButton = (@debt.state < 3) and (@pid isnt @debt.ownerId) and (@pid isnt @debt.winnerId) and not isBidded
		@$scope.showBidStatus = (@debt.state < 3) and isBidded
		@$scope.showCountdown = (@debt.state < 3) or (@debt.state >= 3 and (@pid is @debt.ownerId or @pid is @debt.winnerId))

	getDebtDetail: ->
		@ajaxService.post @actionCode.VIEW_DEBT, {param: @$stateParams.debtId}
			.success (result) =>
				@debt = result
				@init_page_var()
				@init_dialog()
			.error (error) ->
				@$log.log '请求远程资源失败!'
				@$log.log error
				alert error.desc


	# 我要竞标
	bid: ->
		if @debt.state >= DEBT_STATE.DEAL # 只有未成交的单允许竞标
			return
		if @user.money < @$scope.deposit
			@openRechargeModal()
			return
		if @$scope.isBidded
			@$log.log '你已投过标. 不允许重复投标'
			return
		@openBidModal()


	# 中标
	winbid: (playerId)->
		if @debt.state >= DEBT_STATE.DEAL or @pid != @debt.ownerId # 检测
			return
		@ajaxService.post @actionCode.ACTION_BID_WIN, {
			debtId: @debt.id
			playerId: playerId
			}
			.success (result) =>
				# @$log.log result
				@debt = result
			.error (error) =>
				@$log.log error


	# 更新催收动态
	newDebtMsg: (debtMsg)->
		# @$log.log debtMsg
		if not @debtMsgForm.$invalid
			# @$log.log debtMsg.date
			# @$log.log Date.parse debtMsg.date.replace(/-/g,   "/")+" 00:00:00"
			t = Date.parse debtMsg.date.replace(/-/g,   "/")+" 00:00:00" # to milesecond
			@ajaxService.post @actionCode.ACTION_ADD_MESSAGE, {
				id: @debt.id
				time: t / 1000
				type: debtMsg.type.value
				memo: debtMsg.msg
				}
				.success (ret) =>
					@getDebtDetail()
					# reset form
					@debtMsg = {}
					@debtMsgForm.$setPristine()
					@$scope.$broadcast 'show-errors-reset'
					angular.element("#updatedMsgModal").modal "hide"
					
				.error (error) =>
					@$scope.newDebtError = error.desc
	

	# openRechargeModal: ->
	# 	@modalInstance = @$modal.open
	# 		animation: true
	# 		templateUrl: 'recharge.html'
	# 		controller: 'debtModelInstanceController'
	# 		size: 'sm'
	# 		resolve:
	# 			debt: () => @debt

	# 	@modalInstance.result.then ()->
	# 		@$log.log "select"
	# 	, ()->
	# 		@$log.log "dismissed"

	# 	@modalInstance.result.finally =>
	# 		@removeBackdrop()

	openRechargeModal: ->
		angular.element "#rechargeModal"
			.modal()
		true

	openBidModal: ->
		angular.element "#bidModal"
			.modal()
		true

	recharge: ->
		angular.element "#rechargeModal"
			.one 'hidden.bs.modal', (e) =>
				@$state.go 'site.member.pay'
			.modal "hide"
		# return arbitary value instead of the default return value of dom element
		# which will cause angular $parse:isecdom error
		true
		



	# openBidModal: ->
	# 	modalInstance = @$modal.open
	# 		animation: true
	# 		templateUrl: 'bidModel.html'
	# 		controller: 'debtModelInstanceController'
	# 		size: 'sm'
	# 		resolve:
	# 			debt: () => @debt

	# 	modalInstance.result.then () =>
	# 		@getDebtDetail()
			
	# 	, () ->
	# 		@$log.info 'Modal dismissed at: ' + new Date()

	# 	modalInstance.result.finally =>
	# 		@removeBackdrop()


	# removeBackdrop: ->
	# 	# fixed angular 1.4 with ui-bootstrap 0.13.0, modal dialog doesn't fade out issue
	# 	# Reference:  https://github.com/angular-ui/bootstrap/issues/3633
	# 	angular.element(document.querySelectorAll('div.modal')).removeClass('fade').addClass('hidden')
	# 	angular.element(document.querySelectorAll('body')).removeClass('modal-open')
	# 	angular.element(document.querySelectorAll('.modal-backdrop')).remove()
	# 	true


class DebtModelInstanceController
	constructor: (@$log, @$scope, @$modalInstance, @actionCode, @ajaxService, @debt) ->
		$scope.deposit = Math.round(@debt.money * 0.1)
		$scope.debtType = @debt.type
		
		@$scope.ok = () ->
			$modalInstance.close()
		
		@$scope.cancel = () ->
			$modalInstance.dismiss 'cancel'

		@$scope.bid = (price) =>
			if @$scope.bidForm.$valid
				price = parseInt($scope.price)
				data = if @debt.type == 1 then {"rate": price} else {"money": price * 100}
				data['id'] = @debt.id
				@ajaxService.post @actionCode.ACTION_BID, data
					.success (ret) ->
						$log.log ret
						$scope.ok()
					.error (error) ->
						$log.log error
						# alert error.desc
						$scope.error = error.desc



# angular.module("app")
# 	.controller 'debtDetailController', ['$log', '$stateParams', '$scope', '$modal', '$timeout', 'ajaxService', 'actionCode', 'userSession', DebtDetailController]
# 	.controller 'debtModelInstanceController', ['$log', '$scope', '$modalInstance', 'actionCode', 'ajaxService', 'debt', DebtModelInstanceController]

angular.module("app")
	.controller 'debtDetailController', ['$log', '$state', '$stateParams', '$scope', '$timeout', 'ajaxService', 'actionCode', 'userSession', 'growlService', DebtDetailController]
	# .controller 'debtModelInstanceController', ['$log', '$scope', '$modalInstance', 'actionCode', 'ajaxService', 'debt', DebtModelInstanceController]
