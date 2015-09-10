class UploadDebtController
	constructor: (@$log,@$scope, @actionCode, @ajaxService, @userSession,@$state, @$stateParams,@growlService) ->
		@pid = @userSession.pid()
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
		.success (result) =>
			@user=result
		.error (error) =>
			growlService.growl(error.desc, 'danger')

		@upload=(@debtfile)->

			if debtfile is undefined
				growlService.growl("请上传债务文件，仅支持 xls ,xlsx 格式的EXCEL文件！", 'danger')
				return

			debtfile = debtfile[0]
			if checkfiletype(debtfile.id) is false
				growlService.growl("上传债务文件格式有误，仅支持 xls ,xlsx 格式的EXCEL文件！", 'danger')
				return

			# debtfile=splitfiles(debtfile)
			@ajaxService.post @actionCode.ACTION_UPLOAD, debtfile
			.success (result) =>
				growlService.growl('上传债务文件成功，等待后台处理！', 'success')
				$state.go "site.member.uploaddebtlist"
			.error (error) =>
				growlService.growl(error.desc, 'danger')

		checkfiletype =(file)->
			if  (typeof file)!='string'
				return
			isimg=true
			if file != "" and file !=undefined
				idimg=if file=='' then '' else file.split(';')[1]
				imgstring =".xls.xlsx"
				if idimg !=''and idimg !=undefined
					index1=idimg.lastIndexOf(".")
					length=idimg.length
					postf=idimg.substring(index1,length).toLocaleLowerCase()
					if imgstring.indexOf(postf)<0
						isimg=false
			isimg

		splitfiles = (file) ->
			if file != "" and file !=undefined
				filearray = file.split(';')
				data =
					id : filearray[1]
					name : filearray[0]



angular.module('app')
				.controller 'uploaddebtController', ['$log','$scope', 'actionCode', 'ajaxService', 'userSession','$state','$stateParams','growlService', UploadDebtController]
