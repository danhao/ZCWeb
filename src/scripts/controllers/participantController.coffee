
class ParticipantController
	constructor: (@$log,@$scope, @$rootScope, @ajaxService, @actionCode,@userSession, @messageService, @eventConst) ->
		@q =
			type: 1
			state: 2
		@page = 1
		@loadMoreFlag = true
		@debtList = []

		@getList()

		# watch
		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@resetVar()
				@getList()
		, true

		# infinite scroll
		@$rootScope.infiniteScroll = true
		@$scope.$on '$destroy', () =>
			@$rootScope.infiniteScroll = false
		@messageService.subscribe @eventConst.SCROLL_BOTTOM, () =>
			@loadMore()

	loadMore: () =>
		if @loadMoreFlag
			@page++
			@getList()

	resetVar: () =>
		@page = 1
		@loadMoreFlag = true
		@debtList = []
	
	getList: =>
		data = angular.copy(@q)
		data.queryType = 2
		data.page = @page
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, data
			.success (rets) =>
				if rets.debt?
					@debtList = @debtList.concat rets.debt
				else
					@loadMoreFlag = false
			.error (error) =>
				@$log.log error.desc

	# debtFilter: (debt) =>
	# 	p_state = if @q.stateDesc is '1' then debt.state in [0, 1, 2] else debt.state in [3, 4]
	# 	debt.type is @q.type and p_state
		

angular.module("app").controller 'participantController',['$log','$scope', '$rootScope','ajaxService', 'actionCode','userSession', 'messageService', 'eventConst', ParticipantController]

