class AuthemailController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@userSession,@$timeout,@$window,@growlService) ->

		$scope.bntvalue="发送验证邮件"
		initverifyemail=()=>
			@pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: @pid}
			.success (result) =>
				@email=result.email
				$scope.email=result.email
				$scope.isverify =  (result.status&1)==1
			.error (error) =>
				growlService.growl(error, 'danger')

		initverifyemail()
		$scope.timeInMs=60

		countUp = () ->
			$scope.timeInMs--
			if $scope.timeInMs>0
				$scope.bntvalue="发送验证邮件["+$scope.timeInMs+"]"
				$timeout(countUp, 1000)
			else
				$scope.showbntsendemail =false
				$scope.bntvalue="重新发送验证邮件"
				$scope.timeInMs=60
				initverifyemail()

		@verify =(email) ->
			@ajaxService.post actionCode.ACTION_VALIDATE_EMAIL, null
			.success (results) ->
				$scope.showbntsendemail =true
				countUp()
				url="http://mail."+email.split('@')[1]
#				alert('success','激活邮件已发送到您的邮箱,请前往激活！',url)
				growlService.growl('激活邮件已发送到您的邮箱,请前往激活!', 'success')
				$window.open url
			.error (error) ->
				growlService.growl(error, 'danger')


angular.module("app")
	.controller 'authemailController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','userSession','$timeout','$window','growlService', AuthemailController]

