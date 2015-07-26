
class UserDebtListController
	constructor: (@$log,@$scope, @ajaxService, @actionCode,@userSession,@$modal,@rootScope,@messageService,@eventConst) ->
		$scope.agnetstatus =(type,state)->
			agentlist(type,state)
		$scope.transferstatus =(type,state)->
			transferlist(type,state)

		pid=@userSession.pid()
		agentlist = (type=1,state=1) =>
			ListDebtsReq=
				type:type
				state:state
				ownerId:pid
			$log.log(ListDebtsReq)
			ajaxService.post actionCode.LIST_DEBTS, ListDebtsReq
			.success (results) ->
				$scope.agentlist = results.debt
			.error (error) ->
				alert(error)

		transferlist = (type=2,state=1) =>
			ListDebtsReq=
				type:type
				state:state
				ownerId:pid
			$log.log(ListDebtsReq)
			ajaxService.post actionCode.LIST_DEBTS, ListDebtsReq
			.success (results) ->
				$scope.transferlist = results.debt
			.error (error) ->
				alert(error)

		agentlist()
		transferlist()
		#$scope.$watchGroup [@type,@status], ()->
		#	$scope.list =	debtlist(@type,@status)
		#





angular.module("app").controller 'userdebtListController',['$log','$scope','ajaxService', 'actionCode','userSession','$modal', '$rootScope', 'messageService', 'eventConst', UserDebtListController]

