
class DebtListController
	constructor: (@$log,@$scope,@$rootScope,@$state, @$stateParams, @ajaxService, @actionCode, @messageService, @eventConst) ->
		@q =
			fbdate:'0'
			money:'0'
			rate:'0'
			city:''

		@z =
			fbdate:'0'
			money:'0'
			rate:'0'
			city:''

		@page_a = 1
		@page_t = 1
		@$scope.agentlist = []
		@$scope.transferlist = []

		@agentlist = () =>
			data='{type:1,state:1'
			data += getdate(@q.fbdate) if @q.fbdate isnt '0'
			data += getmoney(@q.money) if @q.money isnt '0'
			data +=  ",location:'"+@q.city+"'" if @q.city isnt ''
#			data += ",location:'"+para[2]+"'" if para[2]!=undefined
			data += ",page:"+@page_a
			data +='}'
			# $log.log data
			datajson=angular.toJson data
			ajaxService.post actionCode.LIST_DEBTS, data
			.success (results) =>
				@$scope.agentlist = @$scope.agentlist.concat results.debt
			.error (error) =>
				$log.log error

		@agentlist()


		@transferlist = (para) =>
			data='{type:2,state:1'
			data += getdate(@q.fbdate) if @q.fbdate isnt '0'
			data += getmoney(@q.money) if @q.money isnt '0'
			data +=  ",location:'"+@q.city+"'" if @q.city isnt ''
			#			data += ",location:'"+para[2]+"'" if para[2]!=undefined
			data += ",page:"+@page_t
			data +='}'
			ajaxService.post actionCode.LIST_DEBTS, data
			.success (results) =>
				@$scope.transferlist = @$scope.transferlist.concat results.debt
			.error (error) =>
				$log.log error
				
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


#		$scope.$watchGroup ["fbdate","debtmoney","city","paging"], (para)->
#			$log.log para
#			agentlist(para)
#			transferlist(para)

		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				agentlist()
				transferlist()
		, true



		# infinite scroll
		@messageService.subscribe eventConst.SCROLL_BOTTOM, ()=>
			@loadMore()
			
		@$rootScope.infiniteScroll = true
		@$scope.$on '$destroy', ()=>
			# @$log.log 'destroy'
			@$rootScope.infiniteScroll = false
			

	loadMore: () =>
		# @$log.log 'load more...'
		if @tab == 1
			@page_a++
			@agentlist()
		else
			@page_t++
			@transferlist()
		

angular.module("app").controller 'debtListController',['$log','$scope','$rootScope','$state','$stateParams','ajaxService', 'actionCode', 'messageService', 'eventConst', DebtListController]

