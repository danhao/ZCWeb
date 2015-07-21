
class WonbidController
	constructor: (@$log, @actionCode, @ajaxService) ->
		@ajaxService.post @actionCode.ACTION_LIST_SELF_DEBTS, {param: "3"}
			.success (ret)=>
				@debtList = if ret then ret.debt else []
			.error (ret) ->
				@$log.log ret
			


angular.module('app').controller 'wonbidController', ['$log', 'actionCode', 'ajaxService', WonbidController]
