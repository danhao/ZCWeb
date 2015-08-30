
class Startup
	constructor: (@$log, @$rootScope, @ajaxService, @actionCode, @eventConst, @userSession, @growlService) ->

		# 移动端调用
		@mobilePush = (name, id) ->
			# console.log 'mobile push '+id+';'+name
			try
				apiready = () ->
					api.execScript({
						name: 'root',
						script: 'initPush("' + name + '", "' + id + '");'
						})
			catch err
				@$log.log err
				
		
		# register login event handler
		@$rootScope.$on @eventConst.LOGIN, (event, ret) =>
			# @$log.log "login .."
			@$rootScope.user =
				pid: @userSession.pid()
				sid: @userSession.sid()

			@ajaxService.post @actionCode.UPLOAD_PREPARE, {}
				.success (result) =>
					@$rootScope.ossInfo = result
				.error (error) ->
					@$log.log error

			@mobilePush(ret.name, ret.id)


		# F5
		if @userSession.pid()
			# welcome message
			@ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}
				.success (result) =>
					@$rootScope.$broadcast @eventConst.LOGIN, result
					@growlService.growl('欢迎回来 '+result.name+'!', 'inverse')
				.error (error) =>
					@$log.log error
			


startup = ($log, $rootScope, ajaxService, actionCode, eventConst, userSession, growlService) ->
	new Startup $log, $rootScope, ajaxService, actionCode, eventConst, userSession, growlService


angular.module("app").run ['$log', '$rootScope', 'ajaxService', 'actionCode', 'eventConst', 'userSession', 'growlService', startup]
