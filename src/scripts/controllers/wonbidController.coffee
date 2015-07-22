
class WonbidController
	constructor: (@$log, @$scope, @actionCode, @ajaxService) ->
		@list()
		# @$scope.$watch @stateDesc, () =>
		# 	@$log.log @stateDesc
		# 	@list()

	list: ->
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, {param: "3"}
			.success (ret)=>
				@debtList = if ret then ret.debt else []
			.error (ret) =>
				@$log.log ret


angular.module('app').controller 'wonbidController', ['$log', '$scope', 'actionCode', 'ajaxService', WonbidController]
