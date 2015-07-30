
class WonbidController
	constructor: (@$log, @$scope, @$rootScope, @actionCode, @ajaxService, @eventConst, @messageService) ->
		@q =
			state: 3
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
		data = angular.copy @q
		data.queryType = 3
		data.page = @page
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, data
			.success (ret)=>
				# @debtList = if ret then ret.debt else []
				if ret.debt?
					@debtList = @debtList.concat ret.debt
				else
					@loadMoreFlag = false
			.error (ret) =>
				@$log.log ret

	###
	stateFilter: (debt) =>
		if @$scope.q.stateDesc is '1'
			debt.state in [0, 1, 2, 3]
		else if @$scope.q.stateDesc is '2'
			debt.state is 4
		else
			false
	###


angular.module('app').controller 'wonbidController', ['$log', '$scope', '$rootScope', 'actionCode', 'ajaxService', 'eventConst', 'messageService', WonbidController]
