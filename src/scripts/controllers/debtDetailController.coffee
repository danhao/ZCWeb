
class DebtDetailController

	# 状态
	# DEBT_STATE =
	# 	ALL				: -1
	# 	TO_CHECK		: 0
	# 	CHECKED_PASS	: 1
	# 	CHECKED_FAILED	: 2
	# 	DEAL			: 3
	# 	COMPLETED		: 4

	# 类型
	DEBT_TYPE =
		AGENT:  1
		ASSIGN: 2
		
	
	constructor: (@$log, @$state, @$stateParams, @$scope, @$rootScope, @$timeout, @ajaxService, @actionCode, @constant, @userSession, @growlService, @utilService) ->
		@getDebtDetail()
		@pid = @userSession.pid()
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@user = result
			.error (error) ->
				@$log.log error
				
		@collectionTypes = @constant.debtStatusType
		@contactTypes = @constant.contactType
		@DEBT_STATE = @constant.debtState
		
		@init_calendar()
		


	init_calendar: ->
		@$scope.datePicker = {opened: false}
		@$scope.open_calendar = ($event) =>
			$event.preventDefault()
			$event.stopPropagation()
			@$scope.datePicker.opened = true

	init_dialog: ->
		# 保证金: 10%, 500封顶
		@$scope.deposit = if @debt.type is DEBT_TYPE.AGENT then Math.min(Math.round(@debt.money * 0.1), 500*100) else Math.round(@debt.money * 0.1)
		@$scope.debtType = @debt.type
		@$scope.showDeposit = @debt.type is DEBT_TYPE.AGENT or (@debt.type is DEBT_TYPE.ASSIGN and @pid not in @bidderIds)

		handType = @utilService.getHandTypeByTime @debt.debtExpireTime
		@$scope.rate_min = handType.rate

		# 代理, 费率
		@$scope.agentLegalCheck = (price) =>
			if @debt.type == 1	# 费率
				# 10 <= price <= 100
				@$scope.rate_min*100 <= price <= @debt.rate
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
		# @$log.log @debt
		# @$scope.expireDay = @debt.publishTime*1000 + @debt.expireDays*24*60*60*1000
		# countdown time

		# if @debt.state < 3
		# 	@$scope.countdown_time = @debt.publishTime*1000 + @debt.expireDays*24*60*60*1000
		# else
		# 	@$scope.countdown_time = @debt.publishTime*1000 + @debt.duration*24*60*60*1000

		@$scope.countdown_time = @debt.publishTime*1000 + (if @debt.state < @DEBT_STATE.DEAL then @debt.expireDays else @debt.duration)*24*60*60*1000
			
		@bidderIds = _.map @debt.bidders, (bidder)-> bidder.id
		isBidded = @debt.type is DEBT_TYPE.AGENT and @pid in @bidderIds # 是否已投票

		@$scope.showEditButton = @debt.state is @DEBT_STATE.TO_CHECK and @pid is @debt.ownerId
		@$scope.showBidButton = (@debt.state is @DEBT_STATE.CHECKED_PASS) and (@pid isnt @debt.ownerId) and (@pid isnt @debt.winnerId) and not isBidded
		@$scope.showCreditor = (@debt.state >= @DEBT_STATE.DEAL) and (@pid is @debt.winnerId)
		@$scope.showCountdown = (@debt.state is @DEBT_STATE.CHECKED_PASS) or (@debt.type is DEBT_TYPE.AGENT and @debt.state is @DEBT_STATE.DEAL and (@pid is @debt.ownerId or @pid is @debt.winnerId))
		@$scope.showReturnButton = @debt.canReturn is 1 and @pid is @debt.winnerId
		@$scope.showEndButton = (@debt.state is @DEBT_STATE.DEAL) and @debt.canEnd is 1 and @pid is @debt.winnerId
		
		# 投标状态
		@$scope.bidStatus = switch
			when @debt.state < @DEBT_STATE.DEAL and isBidded then '你已投过标'
			when @debt.state is @DEBT_STATE.DEAL and (isBidded and @pid isnt @debt.winnerId) then '已结束'
			when @debt.state > @DEBT_STATE.DEAL then '已结束'
			else ''

		@$scope.showDebtCollection =
			@debt.type == 1 and	 ( # 债权代理
				( @debt.state >= @DEBT_STATE.DEAL and  (@pid is @debt.ownerId or @pid is @debt.winnerId) ) or # 已成交,且,为发布人或中标人
				( @pid is @debt.ownerId and @debt.messages? and @debt.messages.length > 0 ) # 退单处理
			)


	getDebtDetail: ->
		@ajaxService.post @actionCode.VIEW_DEBT, {param: @$stateParams.debtId}
			.success (result) =>
				@debt = result
				@init_page_var()
				@init_dialog()
				# @$log.log @debt
			.error (error) ->
				@$log.log '请求远程资源失败!'
				@$log.log error
				alert error.desc


	edit: ->
		@$state.go 'site.member.createdebt', {id: @$stateParams.debtId}


	# 我要竞标
	bid: ->
		if @debt.state >= @DEBT_STATE.DEAL # 只有未成交的单允许竞标
			return
		if @user.money < @$scope.deposit
			@openRechargeModal()
			return
		if @$scope.isBidded
			@$log.log '你已投过标. 不允许重复投标'
			return
		@openBidModal()


	# 退单
	returnDebt: ->
		if @debt.state >= @DEBT_STATE.DEAL and @debt.canReturn # 已成交并允许退单
			swal {
				title: '确定退单',
				showCancelButton: true,
				confirmButtonText: "确定",
				cancelButtonText: "取消"
			}, () =>
				@doReturnDebt()
		else
			@growlService.growl "不满足退单条件"

	# 退单
	doReturnDebt: ->
		@ajaxService.post @actionCode.ACTION_RETURN_DEBT, {
			param: @debt.id
			}
			.success (result) =>
				@growlService.growl '退单成功'
				@back()
			.error (error) =>
				@$log.log error
				@growlService.growl error.desc
	
	# 结单
	endDebt: ->
		if @debt.state >= @DEBT_STATE.DEAL and @debt.canEnd # 已成交并且允许结单
			swal {
				title: '确定要申请结单',
				showCancelButton: true,
				confirmButtonText: "确定",
				cancelButtonText: "取消"
			}, () =>
				@doEndDebt()
		else
			@growlService.growl "不满足结单条件"

	# 结单
	doEndDebt: ->
		@ajaxService.post @actionCode.ACTION_APPLY_END_DEBT, {
			param: @debt.id
			}
			.success (result) =>
				@growlService.growl '申请结单成功'
				@back()
			.error (error) =>
				@$log.log error
				@growlService.growl error.desc

	# 中标
	winbid: (playerId)->
		if @debt.state >= @DEBT_STATE.DEAL or @pid != @debt.ownerId # 检测
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
			t = Date.parse debtMsg.date.replace(/-/g,   "/")+" 00:00:00" # to milesecond

			# if debtMsg.fileSelected
			# 	files = _.map debtMsg.fileSelected.split("|"), (item) ->
			# 		tmp = item.split(";")
			# 		{id: tmp[1], name: tmp[0]}
				
			@ajaxService.post @actionCode.ACTION_ADD_MESSAGE, {
				id: @debt.id
				time: t / 1000
				type: debtMsg.type.value
				memo: debtMsg.msg
				# files: files || []
				files: debtMsg.fileSelected
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


	# 新建一个联系人
	newContact: (contact) ->
		unless @contactForm.$invalid
			contact.id = @debt.id
			@$log.log contact
			@ajaxService.post @actionCode.ACTION_ADD_CONTACT, contact
				.success (ret) =>
					@debt.contacts.push contact
					@$scope.contact = {}
					@contactForm.$setPristine()
					@$scope.$broadcast 'show-errors-reset'
					angular.element("#contactModal").modal "hide"
					
				.error (err) =>
					@growlService.growl err.desc

	back: ->
		@$state.go @$rootScope.fromState.name, @$rootScope.toParams


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

	getFileExt: (url) ->
		u1 = url.split("?")[0]
		u2s = u1.split(".")
		u2s[u2s.length-1].toLowerCase()
			
	isImgUrl: (url) ->
		(@getFileExt url) in ["jpg", "jpeg", "ico", "png", "bmp"]
	


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
	.controller 'debtDetailController', ['$log', '$state', '$stateParams', '$scope', '$rootScope', '$timeout', 'ajaxService', 'actionCode', 'constant', 'userSession', 'growlService', 'utilService', DebtDetailController]
	# .controller 'debtModelInstanceController', ['$log', '$scope', '$modalInstance', 'actionCode', 'ajaxService', 'debt', DebtModelInstanceController]
