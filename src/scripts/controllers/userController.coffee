class UserController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@utilService,@growlService) ->

		@ajaxService.post actionCode.GET_USER,null
		.success (result)->
			$log.log result
			setInputValue(result)
			$scope.ismobile=result.mobile!='' ? true:false
			$scope.isemail=result.email!='' ? true:false
		.error (error)->
			growlService.growl(error, 'danger')
			$log.log error

		setInputValue=(userinfo)=>
			@user=userinfo

		$scope.validateOptions =
			blurTrig: true

		@saveEntity = (user)=>
			user.gender= if user.gender==undefined then 0 else parseInt user.gender
			if $scope.ismobile and $scope.isemail
				data=
					userName:user.userName
					gender:user.gender
					address:user.address
			else if $scope.ismobile
				data=
					userName:user.userName
					email:user.email
					gender:user.gender
					address:user.address
			else
				data=
					userName:user.userName
					mobile:user.mobile
					gender:user.gender
					address:user.address

			@ajaxService.post actionCode.ACTION_UPDATE_USER, data
			.success (results) ->
				$scope.ismobile=true
				$scope.isemail=true
				growlService.growl('用户信息更新成功!', 'success')
			.error (error) ->
				$log.log error
				msg = utilService.geterrormsg(error)
				growlService.growl(msg, 'danger')

angular.module("app")
	.controller 'userController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','utilService','growlService', UserController]

