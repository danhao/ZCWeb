class UserPwdController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@md5,@growlService,@utilService) ->
		$scope.validateOptions =
			blurTrig: true

		@changePwd = (@oldPasswd,@newPasswd)->
			oldPasswd = @md5.createHash oldPasswd
			newPasswd = @md5.createHash newPasswd
			@oldPasswd=angular.copy(null)
			@newPasswd=angular.copy(null)
			@repeatPassword=angular.copy(null)
			@ajaxService.post actionCode.ACTION_UPDATE_USER, {oldPasswd:oldPasswd,newPasswd:newPasswd}
			.success (results) ->
				growlService.growl('密码修改成功!', 'success')
				$scope.validateForm = {}
			.error (error) ->
				msg=utilService.geterrormsg(error)
				growlService.growl(msg, 'danger')

angular.module("app")
	.controller 'userPwdController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','md5','growlService','utilService', UserPwdController]

