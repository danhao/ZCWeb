
class WonbidController
	constructor: (@$log, @$scope, @$rootScope, @actionCode, @ajaxService, @eventConst, @constant, @messageService, @handTypeService) ->
		@q =
			state: 3
			hand: -1
		@statusTypes = @constant.debtStatusType
		@resetVar()
		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@resetVar()
				@list()
		, true
		
		@infinitScroll()
		@list()

	infinitScroll: () =>
		@$rootScope.infinitScroll = true
		@$scope.$on '$destroy', () =>
			@$rootScope.infinitScroll = false
		@messageService.subscribe @eventConst.SCROLL_BOTTOM, () =>
			@loadMore()

	resetVar: () =>
		@page = 1
		@loadMoreFlag = true
		@debtList = []

	loadMore: () =>
		if @loadMoreFlag
			@page++
			@list()

	list: =>
		# data = angular.copy @q
		data = _.pick @q, (value, key, object) -> value and value isnt -1;
		data.queryType = 3
		data.page = @page
		data = _.extend data, @getHand()
		# @$log.log data
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, data
			.success (ret)=>
				# @debtList = if ret then ret.debt else []
				if ret.debt?
					@debtList = @debtList.concat ret.debt
				else
					@loadMoreFlag = false
			.error (ret) =>
				@$log.log ret

	
	getHand: =>
		if @q.hand is -1
			{}
		else
			hand = @handTypeService.getTypeByValue @q.hand
			ret = {}
			if hand.from isnt -1
				ret.handFrom = hand.from
			if hand.to isnt -1
				ret.handTo = hand.to
			ret

	query: =>
		unless @q2
			return
		@q.debtorName = @q2.debtorName
		@q.debtorId = @q2.debtorId

	###
	stateFilter: (debt) =>
		if @$scope.q.stateDesc is '1'
			debt.state in [0, 1, 2, 3]
		else if @$scope.q.stateDesc is '2'
			debt.state is 4
		else
			false
	###


angular.module('app').controller 'wonbidController', ['$log', '$scope', '$rootScope', 'actionCode', 'ajaxService', 'eventConst', 'constant', 'messageService', 'handTypeService', WonbidController]
