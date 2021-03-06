class AuthmobileController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@userSession,@$timeout,@growlService) ->
		initverifymobile=()=>
			@pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@mobile=result.mobile
				$scope.mobile=result.mobile
				$scope.isverify =  (result.status&2)==2
				$scope.bntvalue="获取验证码"
				$log.log result
			.error (error) =>
				growlService.growl(error, 'danger')

		initverifymobile()
		$scope.timeInMs=60

		countUp = () ->
			$scope.timeInMs--
			if $scope.timeInMs>0
				$scope.bntvalue="获取验证码["+$scope.timeInMs+"]"
				$timeout(countUp, 1000)
			else
				$scope.showbntsendcode =false
				$scope.bntvalue="重新获取验证码"
				$scope.timeInMs=60

		@sendcode =(@mobile)->
			if mobile==''
				growlService.growl('手机号码不能为空！', 'danger')
				return
			@ajaxService.post actionCode.ACTION_SEND_MOBILE_CODE, null
			.success (results) ->
				$scope.showbntsendcode =true
				countUp()
				growlService.growl('验证码已发送到您的手机，请查收！', 'success')
			.error (error) ->
				growlService.growl(error, 'danger')

		@verify =(code) ->
			@ajaxService.post actionCode.ACTION_VALIDATE_MOBILE, {code:parseInt(code)}
			.success (results) ->
				growlService.growl('手机验证成功!', 'success')
				$state.go 'site.member.index'
			.error (error) ->
				growlService.growl(error.desc, 'danger')


angular.module("app")
	.controller 'authmobileController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','userSession','$timeout','growlService', AuthmobileController]

