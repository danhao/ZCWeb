
class ParticipantController
	constructor: (@$log,@$scope, @ajaxService, @actionCode,@userSession) ->
		@q =
			type: '1'
			state: '1'
		# @pid = @userSession.pid()
		# @$scope.$watch () => @q
		# 	,
		# 	(newValue, oldValue) =>
		# 		if newValue isnt oldValue
		# 			@getList()
		# 	, true
			
		@getList()
		
	
	getList: ->
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, {param: "2"}
			.success (rets) =>
				@debtList = rets.debt
			.error (error) ->
				alert error.desc


angular.module("app").controller 'participantController',['$log','$scope','ajaxService', 'actionCode','userSession', ParticipantController]

