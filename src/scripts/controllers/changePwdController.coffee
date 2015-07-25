class ChangePwdController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@md5,@$timeout,@$window,@growlService) ->
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
#			$log.log data
			@newPasswd=angular.copy(null)
			@repeatPassword=angular.copy(null)
			@ajaxService.post actionCode.ACTION_CHANGE_PWD_THREE, data
			.success (results) ->
#				$log.log results
				growlService.growl('密码修改成功!', 'success')
#				$state.go "site.login({type:1})"
			.error (error) ->
				growlService.growl(error.desc, 'danger')




angular.module("app")
	.controller 'changePwdController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','md5','$timeout','$window','growlService', ChangePwdController]

