class AuthidController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService,@growlService) ->
		$scope.validateOptions =
			blurTrig: true

		initperson=()=>
			pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: pid}
			.success (result) =>
				if result.type==0
					$scope.issubmit = (result.status&4)==4 or result.idValidating==1
					$scope.isverifypass = (result.status&4)==4
				@userinfo = result
			.error (error) =>
				growlService.growl(error, 'danger')
		initperson()

		@verify = (@authid)->
			return if validate(authid)==false
			authid.idFile = splitfiles(authid.idFile,"身份证号")
			if authid.noneCrimeFile isnt undefined
				authid.noneCrimeFile= splitfiles(authid.noneCrimeFile,"无犯罪记录证明")
			if authid.creditFile isnt undefined
				authid.creditFile= splitfiles(authid.creditFile,"个人征信报告")
			authid.idValidating=1
			$log.log authid
			@ajaxService.post actionCode.ACTION_UPDATE_USER, authid
			.success (results) ->
				growlService.growl('身份证信息已提交，请等待后台审核！', 'success')
				$state.go 'site.member.authids'
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
			$log.log auth.idFile
			result = true
			if auth.idFile == '' or auth.idFile == undefined
				growlService.growl("请上传身份证照片，参考拍照攻略！", 'danger')
				result = false

#			if auth.noneCrimeFile == '' or auth.noneCrimeFile == undefined
#				growlService.growl("请上传无犯罪记录证明！", 'danger')
#				result = false
#
#			if auth.creditFile == '' or auth.creditFile == undefined
#				growlService.growl("请上传个人征信报告！", 'danger')
#				result = false
			result



angular.module("app") .controller 'authidController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','utilService','growlService', AuthidController]
