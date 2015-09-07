
class IssuedController
	constructor: (@$log,@$scope,@$stateParams,@ajaxService, @actionCode,@userSession) ->
		@q =
			type: '0'
			state: (@$stateParams.state || -1) + ""

		@pid = @userSession.pid()
		
		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@getList()
		, true
		
		@getList()
		
	
	getList: ->
		param = _.mapObject @q, parseInt
		param.ownerId = @pid
		# @$log.log param
		@ajaxService.post @actionCode.LIST_DEBTS, param
			.success (rets) =>
				@debtList = rets.debt
			.error (error) ->
				alert error.desc


angular.module("app").controller 'issuedController',['$log','$scope','$stateParams','ajaxService', 'actionCode','userSession', IssuedController]

