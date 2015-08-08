
class Controller
	constructor: (@$log, @$rootScope, @$state, @userSession, @eventConst, @ajaxService, @actionCode, @utilService) ->
		@sid = @userSession.sid()
		@$rootScope.$on @eventConst.LOGIN, (name, params) =>
			@sid = params.sid
		@$rootScope.$on @eventConst.LOGOUT, (name, params) =>
			@sid = null

		@pid = @userSession.pid()
		console.log 'header controller'
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
		.success (result) =>
			@user = result
		.error (error) =>
			@$log.log error

	logout: ->
		@userSession.clear()
		@$rootScope.$broadcast @eventConst.LOGOUT
		@$state.go "site.index"
		
		
		
angular.module('app').controller 'headerController',
	['$log', '$rootScope', '$state', 'userSession', 'eventConst', 'ajaxService', 'actionCode', 'utilService', Controller]
