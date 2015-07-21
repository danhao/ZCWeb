class DebtController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@$timeout,@growlService) ->
		@debt =
			city: [ '广东', '深圳市', '南山区' ]

		$scope.step1 = true
		$scope.step2 = false

		$scope.validateOptions =
			blurTrig: true


		$scope.goto = ()->
			$scope.step1 = !$scope.step1
			$scope.step2 = !$scope.step2

		@saveEntity = (@debt)->
			if debt.creditorIdFile is undefined
				growlService.growl("请上传债权人身份证图片！", 'danger')
				return
			else
				debt.creditorIdFile = splitfiles(debt.creditorIdFile)
			sheng = debt.city.cn[0]
			city= debt.city.cn[1]
			area= debt.city.cn[2]
			debt.debtorLocation = sheng+'/'+city+'/'+area
			debt.type = parseInt debt.type
			debt.money *=100
			debt.price = if debt.type==1 then 0 else debt.price*100
			debt.bidIncrease = if debt.type==1 then 0 else debt.bidIncrease*100
			debt.rate = if debt.type==1 then parseInt debt.rate else 0
			debt.duration = if debt.type==1 then  parseInt debt.duration else 0
			debt.expireDays = parseInt debt.expireDays

			debt.debtExpireTime = (Date.parse debt.debtExpireTime) / 1000
			debt.judgementTime  = (Date.parse debt.judgementTime)  / 1000
			if debt.files isnt undefined
				debt.files = splitfiles(debt.files)

			$log.log debt
#			return
			@ajaxService.post actionCode.CREATE_DEBT, debt
			.success (results) ->
				growlService.growl('委托发布成功，请等待后台审核！', 'success')
				$state.go 'site.member.issued'
			.error (error) ->
				growlService.growl(error, 'danger')

		$scope.removeerror = (value,eleid) ->
			if value isnt ''
				elem = angular.element(document.getElementById(eleid))
				group = elem.parent().parent().parent()
				if group isnt '' and group.hasClass("has-error")
					group.removeClass("has-error")
					elem.parent().next(".w5c-error").remove()
			true

		splitfiles = (files) ->
			# $log.log files
			data =
				id : ""
				name : ""
			if files isnt ""
				filelist = files.split('|')
				# $log.log filelist
				if filelist.length > 1
					for file in filelist
						filearray = file.split(';')
						if data.id is ""
							data.id = filearray[1]
							data.name = filearray[0]
						else
							data.id +=";"+filearray[1]
							data.name += ";"+filearray[0]
				else
					filearray = files.split(';')
					data =
						id : filearray[1]
						name : filearray[0]
			data

angular.module("app")
#  .config ["w5cValidatorProvider",
#						 (w5cValidatorProvider)->
#								w5cValidatorProvider.config(
#									blurTrig: false
#									showError: true
#									removeError: true
#								 )
#
#								w5cValidatorProvider.setRules(
#									money:
#										required: "债务总金额不能为空"
#									price:
#										required: "起拍底价不能为空"
#									bidIncrease:
#										required: "加价幅度不能为空"
#									name:
#										required: "债务人姓名不能为空"
#									phone:
#										required: "债务人电话不能为空"
#									idcard:
#										required: "债务人身份证号码不能为空"
#										pattern:  "身份证号码输入有误"
#									address:
#										required: "债务人详细地址不能为空"
#									expiretime:
#										required: "请选择应归还时间"
#									judgementtime:
#										required: "请选择法院判决时间"
#									reason:
#										required: "债务成因不能为空"
#								)
#						 ]
	.controller 'debtController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','$timeout','growlService', DebtController]

