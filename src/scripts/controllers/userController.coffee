class UserController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@utilService,@growlService) ->
		$scope.isshowpic =true
		@ajaxService.post actionCode.GET_USER,null
		.success (result)->
#			$log.log result
			setInputValue(result)
			$scope.ismobile=result.mobile!='' ? true:false
			$scope.isemail=result.email!='' ? true:false
			$scope.avatar = result.head || '../images/profile-pics/1.jpg'
		.error (error)->
			growlService.growl(error.desc, 'danger')
#			$log.log error

		setInputValue=(userinfo)=>
			@user=userinfo

		$scope.validateOptions =
			blurTrig: true

		@saveEntity = (user)=>
			# console.log user
			user.gender= if user.gender==undefined then 0 else parseInt user.gender
			# headimg=if user.head=='' then '' else user.head.split(';')[1]
			headimg=if user.head.length > 0 then user.head[0].id else ''
			console.log headimg
			imgstring =".jpg.jpeg.png.bmp.gif"
			if headimg !=''and headimg !=undefined
#				$log.log headimg
				index1=headimg.lastIndexOf(".")
				length=headimg.length
				postf=headimg.substring(index1,length).toLocaleLowerCase()
				if imgstring.indexOf(postf)<0
					growlService.growl("文件格式有误，仅支持支持jpg, jpeg, png, gif, bmp格式的图片文件！", 'warning')
					return
			if $scope.ismobile and $scope.isemail
				data=
					userName:user.userName
					gender:user.gender
					address:user.address
					companyName:user.companyName
					descript:user.descript
					head:headimg

			else if $scope.ismobile
				data=
					userName:user.userName
					email:user.email
					gender:user.gender
					address:user.address
					companyName:user.companyName
					descript:user.descript
					head:headimg
			else
				data=
					userName:user.userName
					mobile:user.mobile
					gender:user.gender
					address:user.address
					companyName:user.companyName
					descript:user.descript
					head:headimg
#			$log.log data
#			return
			@ajaxService.post actionCode.ACTION_UPDATE_USER, data
			.success (results) ->
				$scope.ismobile=true
				$scope.isemail=true
				growlService.growl('用户信息更新成功!', 'success')
				$state.go 'site.member.index'
			.error (error) ->
#				$log.log error
				msg = utilService.geterrormsg(error)
				growlService.growl(msg, 'danger')

angular.module("app")
	.controller 'userController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','utilService','growlService', UserController]

