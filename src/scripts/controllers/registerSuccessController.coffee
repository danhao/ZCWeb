class Controller
	constructor: (@$log, @$state, @$interval, @userSession, @ajaxService, @actionCode) ->
		@pid = @userSession.pid()
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@user = result
			.error (error) =>
				@$log.log error

		# 5秒后自动跳回个人中心
		@countdown = 5
		@$interval () =>
			@countdown = @countdown - 1
			if @countdown <= 0
				@$state.go 'site.member.index'
		, 1000
		

angular.module('app').controller 'registerSuccessController', ['$log', '$state', '$interval', 'userSession', 'ajaxService', 'actionCode', Controller]
