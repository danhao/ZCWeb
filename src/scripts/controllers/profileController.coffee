class Controller
	constructor: (@$log,@$scope, @actionCode, @ajaxService, @userSession,@$state, @$stateParams,@growlService) ->
		@getUserInfo()

	getUserInfo: ->
		id = @$stateParams.Id
#		$log.log id
		@ajaxService.post @actionCode.ACTION_GET_OTHER, {param: @$stateParams.Id}
		.success (result) =>
			@UserInfo = result
			$log.log result
		.error (error) ->
			@$log.log '请求远程资源失败!'
			@$log.log error
#			growlService.growl(error.desc, 'danger')

angular.module('app')
				.controller 'profileController', ['$log','$scope', 'actionCode', 'ajaxService', 'userSession','$state','$stateParams','growlService', Controller]