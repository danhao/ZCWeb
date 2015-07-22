
class ParticipantController
	constructor: (@$log,@$scope, @ajaxService, @actionCode,@userSession) ->
		@getList()
	
	getList: =>
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, {param: "2"}
			.success (rets) =>
				@debtList = rets.debt
			.error (error) ->
				alert error.desc

	debtFilter: (debt) =>
		p_state = if @q.stateDesc is '1' then debt.state in [0, 1, 2] else debt.state in [3, 4]
		debt.type is @q.type and p_state
		

angular.module("app").controller 'participantController',['$log','$scope','ajaxService', 'actionCode','userSession', ParticipantController]

