
class Controller
	constructor: (@$log, @$rootScope, @$state, @userSession, @eventConst, @ajaxService, @actionCode, @utilService) ->
		@sid = @userSession.sid()
		@$rootScope.$on @eventConst.LOGIN, (name, params) =>
			@sid = params.sid
		@$rootScope.$on @eventConst.LOGOUT, (name, params) =>
			@sid = null

		@pid = @userSession.pid()
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
		.success (result) =>
			@user = result
		.error (error) =>
			@$log.log error

	logout: ->
		@userSession.clear()
		@$rootScope.$broadcast @eventConst.LOGOUT
		@$state.go "site.index"

	fuck: ->
		@ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}
			.success (user) =>
				@$log.log user
			.error (error) =>
				@$log.log error
		# @utilservice.alert '你尚未登陆,无权限查看此页面', 'success'
		
		
		
angular.module('app').controller 'sidebarController',
	['$log', '$rootScope', '$state', 'userSession', 'eventConst', 'ajaxService', 'actionCode', 'utilService', Controller]
