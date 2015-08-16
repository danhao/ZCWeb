
class BaseController
	constructor: (@$log, @$scope, @$state, @growlService, @$rootScope, @$window, @userSession, @eventConst, @ajaxService, @actionCode) ->
		ismobile = false
		
		# Detact Mobile Browser
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			angular.element('html').addClass('ismobile')
			ismobile = true

		@layoutType = localStorage.getItem "ma-layout-status"
		if not ismobile and not @layoutType?
			@layoutType = '1'

		@sidebarToggle =
			left: false
			right: false

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

	scrollTop: ->
		@$window.scrollTo 0,0

	logout: ->
		@userSession.clear()
		@$rootScope.$broadcast @eventConst.LOGOUT
		@$state.go "site.index.home"

	

angular.module("app") .controller 'baseController', ['$log', '$scope', '$state', 'growlService', '$rootScope', '$window', 'userSession', 'eventConst', 'ajaxService', 'actionCode', BaseController]
	
