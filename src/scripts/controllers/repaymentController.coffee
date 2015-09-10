
class RepaymentController
	constructor: (@$log, @$scope, @ajaxService, @userSession, @actionCode, @growlService) ->
		@$log.log 'repayment controller'
		@pid = @userSession.pid()
		@hasMore = true
		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@list()
		, true
		

	query: () ->
		@$log.log 'query'

	list: () ->
		param =
			timeFrom: @q.timeFrom
			timeTo: @q.timeTo
			page: @q.page
			ownerId: @pid
			deputyId: @pid
		@ajaxService.post @actionCode.ACTION_LIST_REPAY, param
			.success (ret) =>
				if ret.debt?
					@debtList = ret.debt
					@hasMore = @debtList? and @debtList.length > 0
			.error (error) =>
				@growlService.growl error.desc, 'danger'

	prev: ->
		if @q.page > 1
			@q.page = @q.page - 1

	next: ->
		if @hasMore
			@q.page = @q.page + 1


angular.module('app').controller 'repaymentController', ['$log', '$scope', 'ajaxService', 'userSession', 'actionCode', 'growlService', RepaymentController]
