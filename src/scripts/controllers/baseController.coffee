
class BaseController
	constructor: (@$log, @$scope, @$state, @growlService, @$rootScope, @userSession, @eventConst, @ajaxService, @actionCode) ->
		@$log.log 'base controller'
		
		# Detact Mobile Browser
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			angular.element('html').addClass('ismobile')

		@sidebarToggle =
			left: false
			right: false

		@layout = localStorage.getItem "ma-layout-status"

		@sid = @userSession.sid()
		@initUser()

		# Login event
		@$rootScope.$on @eventConst.LOGIN, (name, params) =>
			@sid = params.sid
			@initUser()
		@$rootScope.$on @eventConst.LOGOUT, (name, params) =>
			@sid = null

	initUser: ->
		if @sid
			@ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}
			.success (result) =>
				@user = result
			.error (error) =>
				@$log.log error
		
	sidebarStat: (event) ->
		unless angular.element(event.target).parent().hasClass('active')
			@sidebarToggle.left = false

	logout: ->
		@userSession.clear()
		@$rootScope.$broadcast @eventConst.LOGOUT
		@$state.go "site.index"

	

angular.module("app") .controller 'baseController', ['$log', '$scope', '$state', 'growlService', '$rootScope', 'userSession', 'eventConst', 'ajaxService', 'actionCode', BaseController]
	
