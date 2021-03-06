class DebtController
	
	MODE =
		INSERT: 0
		EDIT: 1
	
	constructor: (@$log,@$scope,@$state, @$stateParams,@$window,@ajaxService, @actionCode, @constant, @w5cValidator,@$timeout,@growlService) ->
		@debt =
			city: [ '广东', '深圳市', '南山区' ]
			contacts: []

		$scope.step1 = true
		$scope.step2 = false

		$scope.validateOptions =
			blurTrig: true

		@contactTypes = @constant.contactType

		# edit
		if @$stateParams.id
			@mode = MODE.EDIT
			@$log.log "edit: #{@$stateParams.id}"
			@getDebtDetail()
			

		@goto = () =>
			if @validate1()
				@$scope.step1 = !$scope.step1
				@$scope.step2 = !$scope.step2
				$window.scrollTo 0,0

		@validate1 = () =>
			if @debt.type is 1
				rate = @debt.rate >= 10
				unless rate
					@growlService.growl "代理费率不允许小于10%"
				rate
			else
				true

		@removeRow = (phone) =>
			# @$log.log phone
			@debt.contacts = _.reject(@debt.contacts, (c) -> c.phone is phone)
			
		@addContact = (contact) =>
			unless contact and contact.name and contact.type and contact.phone # 必填
				@growlService.growl '姓名,类型,电话均为必填','danger'
				return
			reg = /((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/
			unless reg.test contact.phone
				@growlService.growl '电话格式不正确,需重新修改','danger'
				return
			if _.any(@debt.contacts, (c) -> c.phone is contact.phone)
				@growlService.growl '输入的电话已存在,请重新输入','danger'
				return
			@debt.contacts.push angular.copy(contact)
			@$scope.contact = {}

		@checkprice =(money,price)->
			if money!=undefined  and price!=undefined and parseInt(price)>=parseInt(money)
				@debt.price=""
				growlService.growl("起拍价格应小于债务总金额！", 'warning')

		@checkbidIncrease =(money,price,bidIncrease)->
			# $log.log money
			# $log.log price
			if money!=undefined  and price!=undefined and bidIncrease!=undefined and  parseInt(price)+parseInt(bidIncrease)>=parseInt(money)
				@debt.bidIncrease=""
				growlService.growl("加价幅度+起拍价格应小于债务总金额！", 'warning')

		@saveEntity = (@debt)->
			# @$log.log 'save....xs'
			if debt.creditorIdFile is undefined
				growlService.growl("请上传债权人身份证图片！", 'danger')
				return
			# else
			# 	if (typeof debt.creditorIdFile)=='string'
			# 		debt.creditorIdFile = splitfiles(debt.creditorIdFile)[0]
			if debt.money*100>2147483648
				growlService.growl("金额超出范围，不能大于21474836.48,请返回上一步修改！", 'danger')
				return
			date = new Date()
			currentdate = (Date.parse  date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate())

			# $log.log debt
			# 转换时间为毫秒,如果是字符串
			if angular.isString debt.judgementTime
				debt.judgementTime = debt.judgementTime.valueOf()
			if angular.isString debt.debtExpireTime
				debt.debtExpireTime = debt.debtExpireTime.valueOf()

			if (Date.parse debt.judgementTime)>currentdate
				growlService.growl("法院判决时间应小于当前时间，请重新选择判决时间！", 'danger')
				return

			if (Date.parse debt.judgementTime)>(Date.parse debt.debtExpireTime)
				growlService.growl("应归还时间应大于法院判决日期，请重新选择应归还时间！", 'danger')
				return

			if (debt.contacts.length < 1)
				growlService.growl '请至少提供一种联系方式', 'danger'
				return

			if debt.city
				sheng = debt.city.cn[0]
				city= debt.city.cn[1]
				area= debt.city.cn[2]
				debt.debtorLocation = sheng+'/'+city+'/'+area
				
			debt.type = parseInt debt.type
			debt.money *= 100

			debt.price = if debt.type==1 then 0 else debt.price*100
			debt.bidIncrease = if debt.type==1 then 0 else debt.bidIncrease*100
			debt.rate = if debt.type==1 then parseInt debt.rate else 0
			debt.duration = if debt.type==1 then  parseInt debt.duration else 0
			debt.expireDays = parseInt debt.expireDays
			debt.property= parseInt debt.property
			debt.debtExpireTime = (Date.parse debt.debtExpireTime) / 1000
			debt.judgementTime  = (Date.parse debt.judgementTime)  / 1000

			# if debt.files isnt undefined && (typeof debt.files)=='string'
			# 	debt.files = splitfiles(debt.files)

			if @mode is MODE.EDIT
				debt.updateId = debt.id
				debt = _.omit(debt, "id", "ownerId", "ownerName", "createTime", "winnerId")
			
			# $log.log debt
#			return
			@ajaxService.post actionCode.CREATE_DEBT, debt
			.success (results) ->
				growlService.growl('委托发布成功，请等待后台审核！', 'success')
				$state.go 'site.member.issued'
			.error (error) ->
				growlService.growl(error.desc, 'danger')

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
			dataarray = []

			if files isnt ""
				filelist = files.split('|')
				# $log.log filelist
				if filelist.length > 1
					for file in filelist
						filearray = file.split(';')
						data =
							id : filearray[1]
							name : filearray[0]
						dataarray.push data
				else
					filearray = files.split(';')
					data =
						id : filearray[1]
						name : filearray[0]
					dataarray.push data
			dataarray

	
	getDebtDetail: ->
		@ajaxService.post @actionCode.VIEW_DEBT, {param: @$stateParams.id}
			.success (result) =>
				@debt = @initEdit(result)
				re = /(\w+)\.debt\.(.+)/
				$(".fg-line :input").each (index, el) ->
					$el = $(el)
					model = $el.attr("ng-model")
					if re.test model
						field = model.replace re, '$2'
						if result[field]
							$el.parent().addClass("fg-toggled")
						
			.error (error) ->
				@$log.log error

	initEdit: (debt) ->
		debt.money = debt.money / 100
		if debt.price
			debt.price = debt.price / 100
		if debt.bidIncrease
			debt.bidIncrease = debt.bidIncrease / 100
		debt.judgementTime = @_time2display(debt.judgementTime)
		debt.debtExpireTime = @_time2display(debt.debtExpireTime)
		debt

	_time2display: (t) ->
		if t is 0 then '' else moment(t*1000).format("YYYY/MM/DD")


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
	.controller 'debtController', ['$log','$scope','$state','$stateParams','$window','ajaxService', 'actionCode', 'constant', 'w5cValidator','$timeout','growlService', DebtController]

