class Controller
	
	constructor: (@$log, @$state, @$stateParams, @$scope, @$rootScope, @$q, @ajaxService, @actionCode, @eventConst, @utilService, @md5, userSession) ->
		# init parameters
		@user = {} if not @user?
		@user.role = @$stateParams.type

		#validator
		@validateAccount = (value) ->
			@utilService.isPhone(value) or @utilService.isEmail(value)

		@mobileEmailExist = (value) ->
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
			

		# register
		@register = (@user) ->
			data = angular.copy(@user)
			data.role = parseInt(@user.role)
			data.passwd = @md5.createHash @user.passwd
			data[if @utilService.isPhone(@user.account) then 'mobile' else 'email'] = @user.account
			if @$scope.registerForm.$valid
				ajaxService.post actionCode.CREATE_USER, data
				.success (results) ->
					userSession.store results.id, results.sid
					$rootScope.$broadcast eventConst.LOGIN, results
					$state.go 'site.register4'
				.error (results, status) ->
					$scope.error = results.desc


angular.module('app').controller 'registerController',
	['$log','$state', '$stateParams', '$scope', '$rootScope', '$q', 'ajaxService', 'actionCode', 'eventConst', 'utilService', 'md5', 'userSession', Controller]
    
