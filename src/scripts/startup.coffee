
class Startup
	constructor: (@$log, @$rootScope, @ajaxService, @actionCode, @eventConst, @userSession, @growlService) ->
		# register login event handler
		@$rootScope.$on @eventConst.LOGIN, (ret) =>
			# @$log.log "login .."
			@$rootScope.user =
				pid: @userSession.pid()
				sid: @userSession.sid()

			@ajaxService.post @actionCode.UPLOAD_PREPARE, {}
				.success (result) =>
					@$rootScope.ossInfo = result
				.error (error) ->
					@$log.log error

		# F5
		if @userSession.pid()
			@$rootScope.$broadcast @eventConst.LOGIN, {}

			# welcome message
			@ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}
				.success (result) =>
					@growlService.growl('欢迎回来 '+result.name+'!', 'inverse')
				.error (error) =>
					@$log.log error
			


startup = ($log, $rootScope, ajaxService, actionCode, eventConst, userSession, growlService) ->
	new Startup $log, $rootScope, ajaxService, actionCode, eventConst, userSession, growlService


angular.module("app").run ['$log', '$rootScope', 'ajaxService', 'actionCode', 'eventConst', 'userSession', 'growlService', startup]
