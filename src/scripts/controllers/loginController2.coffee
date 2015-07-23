class LoginController2
	constructor: (@$log, @$window, @$state, @$stateParams, @$rootScope, @$scope, @$q, @ajaxService, @actionCode, @eventConst, @userSession, @md5, @growlService, @utilService) ->
		angular.element(".login-content").height angular.element(@$window).height()
		type = @$stateParams.type
		@showLogin = if (not type or type is '1') then 1 else 0
		@showRegister = if type is '2' then 1 else 0
		@showForgot = 0
		$scope.changepwdstep1=true
		$scope.changepwdstep2=false
		$scope.changepwdstep3=false

		@sendcode =(@forgetpwd) ->
			$scope.type = parseInt forgetpwd.type
			if $scope.type==2
				$scope.email=forgetpwd.email
				data =
					email:forgetpwd.email
			else
				$scope.mobile=forgetpwd.mobile
				data =
					mobile:forgetpwd.mobile
			$log.log data
			#			return
			@ajaxService.post actionCode.ACTION_CHANGE_PWD_ONE, data
			.success (results) ->
				$scope.changepwdstep1=false
				$scope.changepwdstep2=true
				$scope.changepwdstep3=false
				$log.log $scope.type
				if $scope.type==1
					growlService.growl('验证已发送到手机，请查收!', 'success')
				else
					growlService.growl('验证已发送到邮箱，请查收!', 'success')
					url="http://mail."+forgetpwd.email.split('@')[1]
					$window.open url

				$log.log $scope.type
			.error (error) ->
				if $scope.type==2
					msg= if error.code='103'  then '邮箱不存在' else error.desc
				else
					msg= if error.code='103'  then '手机号码不存在' else error.desc
				growlService.growl(msg, 'danger')
				$log.log error


		@verifycode = (@code)->
			$scope.code=code
			if $scope.type==2
				data =
					email:$scope.email
					code:code
			else
				data =
					mobile:$scope.mobile
					code:code
			$log.log data
			@ajaxService.post actionCode.ACTION_CHANGE_PWD_TWO, data
			.success (results) ->
				$scope.changepwdstep1=false
				$scope.changepwdstep2=false
				$scope.changepwdstep3=true
				$log.log results
			.error (error) ->
				growlService.growl(error.desc, 'danger')

		@changePwd = (@newPasswd)->
			passwd = @md5.createHash newPasswd
			#			$log.log $scope.type
			#			$log.log $scope.type==2
			if $scope.type==2
				data =
					email:$scope.email
					code:$scope.code
					passwd:passwd
			else
				data =
					mobile:$scope.mobile
					code:$scope.code
					passwd:passwd
			$log.log data
			@newPasswd=angular.copy(null)
			@repeatPassword=angular.copy(null)
			@ajaxService.post actionCode.ACTION_CHANGE_PWD_THREE, data
			.success (results) ->
				$log.log results
				growlService.growl('密码修改成功!', 'success')
				@showForgot = 0
				@showLogin = 1
			.error (error) ->
				growlService.growl(error.desc, 'danger')
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
