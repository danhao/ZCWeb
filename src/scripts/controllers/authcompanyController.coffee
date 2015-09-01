class AuthcompanyController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@growlService) ->
		$scope.validateOptions =
			blurTrig: true

		initcompany=()=>
			pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: pid}
			.success (result) =>
				$scope.issubmit = (result.status&8) is 8 or result.coValidating is 1
				$scope.isverifypass = (result.status&8) is 8
				$scope.isshowidFile = if result.idFile then isshowpic(result.idFile.name) else false
				$scope.isshowaccountPermitFile = if result.accountPermitFile then isshowpic(result.accountPermitFile.name) else false
				$scope.isshoworganizationCodeFile = if result.organizationCodeFile then isshowpic(result.organizationCodeFile.name) else false
				$scope.isshowbusinessLicenceFile = if result.businessLicenceFile then isshowpic(result.businessLicenceFile.name) else false
				$scope.isshowtaxNumberFile = if result.taxNumberFile then isshowpic(result.taxNumberFile.name) else false
				@user = result
			.error (error) =>
				growlService.growl(error, 'danger')
		initcompany()

		@verifycompany = (@authcompany)->
			return if validate(authcompany)==false

			authcompany.reqisteredType = parseInt authcompany.reqisteredType
			authcompany.foundTime= (Date.parse authcompany.foundTime) / 1000
			
			# if (typeof authcompany.idFile)=='string'
			# 	authcompany.idFile = splitfiles(authcompany.idFile)

			# if (typeof authcompany.accountPermitFile)=='string'
			# 	authcompany.accountPermitFile= splitfiles(authcompany.accountPermitFile)

			# if authcompany.organizationCodeFile isnt undefined and (typeof authcompany.organizationCodeFile)=='string'
			# 	authcompany.organizationCodeFile= splitfiles(authcompany.organizationCodeFile)

			# if (typeof authcompany.businessLicenceFile)=='string'
			# 	authcompany.businessLicenceFile = splitfiles(authcompany.businessLicenceFile)

			# if authcompany.taxNumberFile isnt undefined and (typeof authcompany.taxNumberFile)=='string'
			# 	authcompany.taxNumberFile= splitfiles(authcompany.taxNumberFile)
				
			authcompany.coValidating=1
			authcompany.fiveInOne =parseInt authcompany.fiveInOne
#			$log.log authcompany
#			return
			@ajaxService.post actionCode.ACTION_UPDATE_USER, authcompany
			.success (results) ->
				growlService.growl('企业信息已提交，请等待后台审核！', 'success')
				$state.go 'site.member.authcompanys'
			.error (error) ->
				growlService.growl(error, 'danger')

		isshowpic =(filename) ->
			imgstring =".jpg.jpeg.png.bmp.gif"
			index1=filename.lastIndexOf(".")
			length=filename.length
			postf=filename.substring(index1,length).toLocaleLowerCase()
#			$log.log filename
			if imgstring.indexOf(postf)<0
				isimg=false
			else
				isimg =true
			isimg

		splitfiles = (files) ->
			filearray = files.split(';')
			data =
				id : filearray[1]
				name : filearray[0]

		validate = (auth) ->
#			$log.log auth
			result = true
			date = new Date()
			currentdate = (Date.parse  date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate())
			if (Date.parse auth.foundTime)>=currentdate
				growlService.growl("企业成立时间应小于当前时间，请重新选择企业成立时间！", 'danger')
				result = false

			if auth.idFile == '' or auth.idFile == undefined
				growlService.growl("请上传身份证照片，参考拍照攻略！", 'danger')
				result = false

			if auth.accountPermitFile == '' or auth.accountPermitFile == undefined
				growlService.growl("请上传开户许可证！", 'danger')
				result = false

			if (auth.organizationCodeFile == '' or auth.organizationCodeFile == undefined) and auth.fiveInOne=="0"
				growlService.growl("请上传组织机构代码证！", 'danger')
				result = false

			if auth.businessLicenceFile == '' or auth.businessLicenceFile == undefined
				growlService.growl("请上传工商营业执照！", 'danger')
				result = false

			if (auth.taxNumberFile == '' or auth.taxNumberFile == undefined) and auth.fiveInOne=="0"
				growlService.growl("请上传税务登记证！", 'danger')
				result = false
			result
angular.module("app")
	.controller 'authcompanyController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','growlService', AuthcompanyController]

