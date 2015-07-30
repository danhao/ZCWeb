class AuthidController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService,@growlService) ->
		$scope.validateOptions =
			blurTrig: true
		initperson=()=>
			pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: pid}
			.success (result) =>
#				if result.type==0
				$scope.issubmit = (result.status&4) is 4 or result.idValidating is 1
				$scope.isverifypass = (result.status&4) is 4
				@userinfo = result
				@authid=result
				@userinfo.isshowcreditFile=true
				if @userinfo.creditFile==undefined
					@userinfo.isshowcreditFile=false
				else
					file ="a;"+@userinfo.creditFile.name
					if checkfiletype(file)==false
						@userinfo.isshowcreditFile=false
			.error (error) =>
				growlService.growl(error, 'danger')
		initperson()

		@verify = (@authid)->
			return if validate(authid)==false
#			$log.log authid
			if checkfiletype(authid.idFile)==false
				growlService.growl("身份证文件文件格式有误，仅支持支持jpg, jpeg, png, gif, bmp格式的图片文件！", 'warning')
				return
			else
				if (typeof authid.idFile)=='string'
					authid.idFile = splitfiles(authid.idFile)

			if authid.noneCrimeFile isnt undefined
				if checkfiletype(authid.noneCrimeFile)==false
					growlService.growl("无犯罪记录证明文件文件格式有误，仅支持支持jpg, jpeg, png, gif, bmp格式的图片文件！", 'warning')
					return
				else
					if (typeof authid.noneCrimeFile)=='string'
						authid.noneCrimeFile= splitfiles(authid.noneCrimeFile)

			if authid.creditFile isnt undefined
				if (typeof authid.creditFile)=='string'
					authid.creditFile= splitfiles(authid.creditFile)

#			$log.log authid.idValidating

			if (authid.status&4) is 4
				data =
					idValidating:1
					creditFile:authid.creditFile if authid.creditFile.id isnt undefined
					noneCrimeFile:authid.noneCrimeFile if authid.noneCrimeFile.id isnt undefined
			else if authid.idValidating is 0
				data =
					idValidating:1
					userId :authid.userId
					idFile :authid.idFile
					creditFile:authid.creditFile if authid.creditFile isnt undefined
					noneCrimeFile:authid.noneCrimeFile if authid.noneCrimeFile isnt undefined
			else
#				$log.log authid.idFile.id
				data =
					idValidating:1
					userId :authid.userId
					idFile :authid.idFile if authid.idFile.id isnt undefined
					creditFile:authid.creditFile if authid.creditFile isnt undefined and authid.creditFile.id isnt undefined
					noneCrimeFile:authid.noneCrimeFile if authid.noneCrimeFile isnt undefined and authid.noneCrimeFile.id isnt undefined


			@ajaxService.post actionCode.ACTION_UPDATE_USER, data
			.success (results) ->
				info =if  $scope.isverifypass then '个人验证信息已提交成功！' else '个人验证信息已提交，请等待后台审核！'
				growlService.growl(info, 'success')
				$state.go 'site.member.authids'
			.error (error) ->
				growlService.growl(error.desc, 'danger')

		checkfiletype =(file)->
			if  (typeof file)!='string'
				return
			isimg=true
			if file != "" and file !=undefined
				idimg=if file=='' then '' else file.split(';')[1]
				imgstring =".jpg.jpeg.png.bmp.gif"
				if idimg !=''and idimg !=undefined
					index1=idimg.lastIndexOf(".")
					length=idimg.length
					postf=idimg.substring(index1,length).toLocaleLowerCase()
					if imgstring.indexOf(postf)<0
						isimg=false
			isimg
#						growlService.growl(typename+"文件格式有误，仅支持支持jpg, jepg, png, gif, bmp格式的图片文件！", 'warning')
#						return

		splitfiles = (file,type) ->
			if file != "" and file !=undefined
				filearray = file.split(';')
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
