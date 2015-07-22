class LoginController2
	constructor: (@$log, @$window, @$state, @$stateParams, @$rootScope, @$scope, @$q, @ajaxService, @actionCode, @eventConst, @userSession, @md5, @growlService, @utilService) ->
		angular.element(".login-content").height angular.element(@$window).height()
		type = @$stateParams.type
		@showLogin = if (not type or type is '1') then 1 else 0
		@showRegister = if type is '2' then 1 else 0
		@showForgot = 0
		# @$log.log '@showLogin:'+@showLogin+'; @showRegister:'+@showRegister + '; @showForgot:'+@showForgot
		

	# login function
	login: (loginForm, @luser) ->
		# @$log.log @luser
		if loginForm.$valid
			data =
				passwd: @md5.createHash @luser.password
			data[ if (@luser.identity.indexOf "@") > 0 then "email" else "mobile"] = @luser.identity
			opt = {expires: @oneWeekLater()} if @luser.remember
			@ajaxService.post @actionCode.LOGIN, data
				.success (result) =>
					@userSession.store result.id, result.sid, opt
					@$rootScope.$broadcast @eventConst.LOGIN, result
					@$state.go 'site.member.index'
				.error (result) =>
					@growlService.growl result.desc, 'danger'

	# register
	register: (registerForm, @user) ->
		# @$log.log @user
		# @$log.log registerForm.$valid
		unless @user and registerForm.$valid
			return
		data = angular.copy(@user)
		data.role = parseInt(@user.role)
		data.passwd = @md5.createHash @user.passwd
		data[if @utilService.isPhone(@user.account) then 'mobile' else 'email'] = @user.account
		if registerForm.$valid
			@ajaxService.post @actionCode.CREATE_USER, data
				.success (results) =>
					@userSession.store results.id, results.sid
					@$rootScope.$broadcast @eventConst.LOGIN, results
					@$state.go 'site.register4'
				.error (results, status) ->
					@growlService.growl results.desc, 'danger'


	# helper
	oneWeekLater: () ->
		n = new Date()
		n.setDate n.getDate()+7
		n

	# validator
	validateAccount: (value) ->
		@utilService.isPhone(value) or @utilService.isEmail(value)

	mobileEmailExist: (value) ->
		data = {}
		if @utilService.isPhone value
			data["mobile"] = value
		else if @utilService.isEmail value
			data['email'] = value
		else
			return true

		deferred = @$q.defer()
		@ajaxService.post @actionCode.VALIDATE_EMAIL_MOBILE, data
			.success (result) ->
				deferred.resolve true
			.error (error) ->
				deferred.reject false
		deferred.promise


angular.module("app").controller 'loginController2',
	['$log', '$window', '$state', '$stateParams', '$rootScope', '$scope', '$q', 'ajaxService', 'actionCode', 'eventConst', 'userSession', 'md5', 'growlService', 'utilService', LoginController2]
