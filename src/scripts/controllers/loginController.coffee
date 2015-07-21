class LoginController
	constructor: (@$log, @$state, @$rootScope, @$scope, @ajaxService, @actionCode, @eventConst, @userSession, @md5) ->
		@login = () =>
			if $scope.loginForm.$valid
				data =
					passwd: @md5.createHash @password
				data[ if (@identity.indexOf "@") > 0 then "email" else "mobile"] = @identity
				opt = {expires: @oneWeekLater()} if @remember
				@ajaxService.post @actionCode.LOGIN, data
					.success (result) =>
						userSession.store result.id, result.sid, opt
						$rootScope.$broadcast eventConst.LOGIN, result
						# $log.log "broadcast login"
						@error = ""
						@$state.go 'site.member.index'
					.error (result) =>
						@error = result.desc

	oneWeekLater: () ->
		n = new Date()
		n.setDate n.getDate()+7
		n

angular.module("app").controller 'loginController', ['$log', '$state', '$rootScope', '$scope', 'ajaxService', 'actionCode', 'eventConst', 'userSession', 'md5', LoginController]

