
class RepaymentController
	constructor: (@$log, @$scope, @ajaxService, @userSession, @actionCode, @growlService) ->
		@q =
			timeFrom: moment().startOf("month").format("YYYY/MM/DD")
			timeTo: moment().format("YYYY/MM/DD")
			page: 1
		@pid = @userSession.pid()
		@hasMore = true
		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				@list()
		, true
		@list()

	query: () ->
		unless @q2
			return
		@q.debtId = @q2.keyword

	list: () ->
		param =
			timeFrom: moment(new Date(@q.timeFrom)).unix()
			timeTo: moment(new Date(@q.timeTo)).add(1, "d").unix()
			page: @q.page
			ownerId: @pid
			deputyId: @pid
		param.debtId = @q.debtId if @q.debtId
		# @$log.log param
		@ajaxService.post @actionCode.ACTION_LIST_REPAY, param
			.success (ret) =>
				# @$log.log ret
				@debtList = ret.repay || []
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
