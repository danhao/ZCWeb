
class DebtListController
	constructor: (@$log,@$scope,@$rootScope,@$state, @$stateParams, @ajaxService, @actionCode, @messageService, @eventConst, @growlService, @handTypeService, @userSession) ->
		@q =
			fbdate:'0'
			money:'0'
			rate:'0'
			city:''
			hand:-1
			keyword: ''

		@z =
			fbdate:'0'
			money:'0'
			rate:'0'
			city:''

		@pid = @userSession.pid()

		@page_a = 1
		@page_t = 1
		@loadMore_a = true
		@loadMore_t = true
		@$scope.agentlist = []
		@$scope.transferlist = []

		# @showCheck = false
		@checkStatus = 0

		# 查询还能接单的数量
		@ajaxService.post @actionCode.ACTION_DEBT_COUNT, {}
			.success (result) =>
				@allowDebtCount = result.param
			.error (error) =>
				@$log.log error

		# 查询当前用户的余额
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@user = result
			.error (error) ->
				@$log.log error

		
		gethand=(value)->
			$log.log value
			if value is -1
				return ret = ""
			else
				hand = handTypeService.getTypeByValue value
				s = []
				if hand.from isnt -1
					s.push('handFrom:'+hand.from)
				if hand.to isnt -1
					s.push('handTo:'+hand.to)
				return ret = if s.length is 0 then "" else ("," + s.join(","))


		@agentlist = () =>
			@$log.log @q
			data='{type:1,state:1'
			data += getdate(@q.fbdate) if @q.fbdate isnt '0'
			data += getmoney(@q.money) if @q.money isnt '0'
			data += gethand(@q.hand)
			data += (",keyword:'"+@q.keyword+"'") if @q.keyword isnt ''
			data +=  ",location:'"+@q.city+"'" if @q.city isnt ''
			data += ",page:"+@page_a
			data +='}'
			datajson=angular.toJson data
			@$log.log datajson
			ajaxService.post actionCode.LIST_DEBTS, data
			.success (results) =>
				if results.debt?
					@$scope.agentlist = @$scope.agentlist.concat results.debt
				else
					@loadMore_a = false
			.error (error) =>
				@$log.log error

		@agentlist()


		@transferlist = (para) =>
			data='{type:2,state:1'
			data += getdate(@q.fbdate) if @q.fbdate isnt '0'
			data += getmoney(@q.money) if @q.money isnt '0'
			data += gethand(@q.hand)
			data += (",keyword:'"+@q.keyword+"'") if @q.keyword isnt ''
			data +=  ",location:'"+@q.city+"'" if @q.city isnt ''
			data += ",page:"+@page_t
			data +='}'
			ajaxService.post actionCode.LIST_DEBTS, data
			.success (results) =>
				if results.debt?
					@$scope.transferlist = @$scope.transferlist.concat results.debt
				else
					@loadMore_t = false
			.error (error) =>
				@$log.log error
				
		@transferlist()

		getdate=(value)->
			date = new Date()
			timestramp = Date.parse date
			currentdate = timestramp/1000
			zeropoint = new Date(date.getFullYear(),date.getMonth(),date.getDate(),0,0,1).getTime()/1000
			datestr=''
			switch value
				when '1' then  datestr=",createTimeFrom:"+zeropoint+",createTimeTo:"+currentdate+""
				when '7' then datestr=",createTimeFrom:"+(timestramp-7*86400000)/1000+",createTimeTo:"+currentdate+""
				when '30' then datestr=",createTimeFrom:"+(timestramp-30*86400000)/1000+",createTimeTo:"+currentdate+""
				when '365' then datestr=",createTimeFrom:"+(timestramp-365*86400000)/1000+",createTimeTo:"+currentdate+""
				else datastr=''

		
		

		getmoney=(value)->
			moneystr=''
			switch value
				when '1' then moneystr=",moneyLow:100,moneyUp:1000000"
				when '2' then moneystr=",moneyLow:1000000,moneyUp:10000000"
				when '3' then moneystr=",moneyLow:10000000,moneyUp:50000000"
				when '4' then moneystr=",moneyLow:50000000,moneyUp:100000000"
				when '5' then moneystr=",moneyLow:100000000,moneyUp:0"
				else moneystr=''

		
		@reset_var = () =>
			@$scope.agentlist = []
			@$scope.transferlist = []
			@page_a = 1
			@page_t = 1
			@loadMore_a = true
			@loadMore_t = true

		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@reset_var()
				
				@agentlist()
				@transferlist()
		, true
		

		# init modal
		@initDialog()

		# infinite scroll
		@messageService.subscribe eventConst.SCROLL_BOTTOM, ()=>
			@loadMore()
			
		@$rootScope.infiniteScroll = true
		@$scope.$on '$destroy', ()=>
			@$rootScope.infiniteScroll = false
		

	initDialog: () ->
		# 表单检测
		@$scope.agentLegalCheck = (price) =>
			10 <= price <= 100

		# 提交函数
		@$scope.bidPrice = () =>
			if @$scope.bidForm.$valid
				price = parseInt(@$scope.price)
				data = {"rate": price}
				data.id = _.map (_.filter @$scope.agentlist, (debt) -> debt.checked)
					, (debt) -> debt.id
				data.bond = @$scope.deposit
				# @$log.log data
				@ajaxService.post @actionCode.ACTION_BATCH_BID, data
					.success (ret) =>
						# reset form
						@$scope.price = ""
						@$scope.bidForm.$setPristine()
						@$scope.$broadcast 'show-errors-reset'
						
						angular.element "#bidModal"
							.modal "hide"
						@growlService.growl "批量投标成功"
						@checkAll 2
					.error (error) =>
						@$log.log error
						# alert error.desc
						@growlService.growl error.desc, 'warning'

	loadMore: () =>
		# @$log.log 'load more...'
		if @tab is 1 and @loadMore_a
			@page_a++
			@agentlist()
		else if @tab is 2 and @loadMore_b
			@page_t++
			@transferlist()

	checkAll: (checkStatus)->
		# @showCheck = !@showCheck
		if(checkStatus is 1) 	# check all
			_.each @$scope.agentlist, (debt) -> debt.checked = true
		else if(checkStatus is 2)
			_.each @$scope.agentlist, (debt) -> debt.checked = false
		# update checkStatus
		@checkStatus = (checkStatus+1) % 3

	batchBid: ->
		if @tab is 2
			return
		checkedList = _.filter @$scope.agentlist, (debt) -> debt.checked
		# @$log.log _.any checkedList, (debt) => debt.ownerId is @pid
		if checkedList.length is 0
			@growlService.growl '您没有选择任何记录,请先选择后再进行操作.'
			return
		else if checkedList.length > @allowDebtCount
			@growlService.growl '您最多只允许再投标'+@allowDebtCount+'单,您的选择过多,请重新选择.'
			return
		else if (_.any checkedList, (debt) => debt.ownerId is @pid)
			@growlService.growl '您不允许投标自己发布的记录,请重新选择.'
			return
		else if (_.any checkedList, (debt) -> debt.hasBid)
			@growlService.growl '您选择的记录中,存在已经投过的标,请重新选择.'
			return
		else
			# init dialog var
			@$scope.selectedCount = checkedList.length
			# sum money
			@$scope.deposit = _.reduce _.map(checkedList, (debt) -> Math.min(Math.round(debt.money * 0.1), 500*100))
				,
				(memo, num) -> memo + num
				,
				0
			# @$log.log @$scope.selectedCount + " -- " + @$scope.deposit
			# @$log.log @user.money + "--" + @$scope.deposit
			if @user.money < @$scope.deposit # 金额不足
				angular.element "#rechargeModal"
					.modal()
			else
				angular.element "#bidModal"
					.modal()
		true

	# 充值
	recharge: ->
		angular.element "#rechargeModal"
			.one 'hidden.bs.modal', (e) =>
				@$state.go 'site.member.pay'
			.modal "hide"
		# return arbitary value instead of the default return value of dom element
		# which will cause angular $parse:isecdom error
		true

	query: ->
		# @$log.log @q2.keyword
		@q.keyword = @q2.keyword
		
		

angular.module("app").controller 'debtListController',['$log','$scope','$rootScope','$state','$stateParams','ajaxService', 'actionCode', 'messageService', 'eventConst', 'growlService', 'handTypeService', 'userSession', DebtListController]

