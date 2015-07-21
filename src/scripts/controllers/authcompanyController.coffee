class AuthcompanyController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@growlService) ->
		$scope.validateOptions =
			blurTrig: true

		initcompany=()=>
			pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: pid}
			.success (result) =>
				if result.type==1
					$scope.issubmit = (result.status&8)==8 or result.userId!=''
					$scope.isverifypass = (result.status&8)==8

				$log.log result
				@user = result
			.error (error) =>
				growlService.growl(error, 'danger')
		initcompany()

		@verifycompany = (@authcompany)->
			return if validate(authcompany)==false
			authcompany.reqisteredType = parseInt authcompany.reqisteredType
			authcompany.foundTime= (Date.parse authcompany.foundTime) / 1000
			authcompany.idFile = splitfiles(authcompany.idFile,"法定代表人身份证照片")
			authcompany.accountPermitFile= splitfiles(authcompany.accountPermitFile,"开户许可证")
			authcompany.organizationCodeFile= splitfiles(authcompany.organizationCodeFile,"组织机构代码证")
			authcompany.businessLicenceFile = splitfiles(authcompany.businessLicenceFile,"工商营业执照")
			authcompany.taxNumberFile= splitfiles(authcompany.taxNumberFile,"税务登记证")
			$log.log authcompany
#			return
			@ajaxService.post actionCode.ACTION_UPDATE_USER, authcompany
			.success (results) ->
				growlService.growl('企业信息已提交，请等待后台审核！', 'success')
				$state.go 'site.member.authcompanys'
			.error (error) ->
				growlService.growl(error, 'danger')


		splitfiles = (files,type) ->
			if files != ""
				$log.log files.split('|').length
				if files.split('|').length > 1
					growlService.growl(type+"只能上传一个图片", 'danger')
				else
					filearray = files.split(';')
					data =
						id : filearray[1]
						name : filearray[0]

		validate = (auth) ->
			result = true
			if auth.idFile == '' or auth.idFile == undefined
#				alert('danger',"请上传法人身份证照片，参考拍照攻略！")
				growlService.growl("请上传身份证照片，参考拍照攻略！", 'danger')
				result = false

			if auth.accountPermitFile == '' or auth.accountPermitFile == undefined
#				alert('danger',"请上传开户许可证！")
				growlService.growl("请上传开户许可证！", 'danger')
				result = false

			if auth.organizationCodeFile == '' or auth.organizationCodeFile == undefined
#				alert('danger',"请上传组织机构代码证！")
				growlService.growl("请上传组织机构代码证！", 'danger')
				result = false

			if auth.businessLicenceFile == '' or auth.businessLicenceFile == undefined
#				alert('danger',"请上传工商营业执照！")
				growlService.growl("请上传工商营业执照！", 'danger')
				result = false

			if auth.taxNumberFile == '' or auth.taxNumberFile == undefined
#				alert('danger',"请上传税务登记证！")
				growlService.growl("请上传税务登记证！", 'danger')
				result = false
			result
angular.module("app")
	.controller 'authcompanyController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','growlService', AuthcompanyController]

