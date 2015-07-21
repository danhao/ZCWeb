
class IndexController
	constructor: (@$log, @ajaxService, @actionCode) ->
		@ajaxService.post @actionCode.ACTION_LIST_VIEW_DEBTS, {type: 1, state: 1}
			.success (result) =>
				@debtList = result.debt
			.error (error) ->
				@$log.log error

		

angular.module('app').controller 'indexController', ['$log', 'ajaxService', 'actionCode', IndexController]
