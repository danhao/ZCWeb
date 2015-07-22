
class WonbidController
	constructor: (@$log, @$scope, @actionCode, @ajaxService) ->
		@list()
		# @$scope.$watch 'q.stateDesc', ()=>
		# 	@$log.log @$scope.q.stateDesc

	list: =>
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, {param: "3"}
			.success (ret)=>
				@debtList = if ret then ret.debt else []
			.error (ret) =>
				@$log.log ret

	stateFilter: (debt) =>
		if @$scope.q.stateDesc is '1'
			debt.state in [0, 1, 2, 3]
		else if @$scope.q.stateDesc is '2'
			debt.state is 4
		else
			false


angular.module('app').controller 'wonbidController', ['$log', '$scope', 'actionCode', 'ajaxService', WonbidController]
