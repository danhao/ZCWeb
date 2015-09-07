
class RepaymentController
	constructor: (@$log, @$scope) ->
		@$log.log 'repayment controller'


angular.module('app').controller 'repaymentController', ['$log', '$scope', RepaymentController]
