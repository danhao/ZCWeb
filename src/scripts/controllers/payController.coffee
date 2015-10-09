class PayController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService,@growlService, @$window, @$http) ->
		$scope.validateOptions =
			blurTrig: true

		# returnUrl = "#{@$window.location.protocol}//#{@$window.location.host}/#!/member"

		payinfo =
			version: '2.1'
			tranCode: '8888'
			tranAmt: ''
			feeAmt: ''
			# frontMerUrl: returnUrl
			tranDateTime: ''

		@pay=(money)->
			if money>10000000
				growlService.growl("充值金额不能大于1000万元！", 'danger')
				return
			payinfo.tranAmt = money.toString()
			payinfo.tranDateTime = moment().format("YYYYMMDDHHmmss")
			@ajaxService.post @actionCode.ACTION_CREATE_ORDER, payinfo
			.success (result) =>
				$log.log result
				submit(result)
			.error (error) =>
				growlService.growl(error.desc, 'danger')

		submit =(payrsp) ->
			$scope.pay =
				version: payinfo.version
				charset: '2'
				language: '1'
				signType: '1'
				tranCode: payinfo.tranCode
				merchantID: payrsp.merchantId
				merOrderNum: payrsp.merOrderNum
				tranAmt: payinfo.tranAmt
				feeAmt: payinfo.feeAmt
				currencyType: '156'
				# frontMerUrl: payinfo.frontMerUrl
				backgroundMerUrl: payrsp.backgroundMerUrl
				tranDateTime: payinfo.tranDateTime
				virCardNoIn: '0000000002000003896' # test:'0000000002000000257'  prod:'0000000002000003896'
				tranIP: payrsp.transIp
				# isRepeatSubmit: ''
				# goodsName: ''
				# goodsDetail: ''
				# buyerName: ''
				# buyerContact: ''
				merRemark1: payrsp.merRemark1
				merRemark2: ''
				# bankCode: ''
				# userType: ''
				# VerficationCode: ''
				gopayServerTime: payrsp.serverTime
				signValue: payrsp.signValue
			
			# document.getElementById("payform").submit()
			# $scope.$apply()
			# form= angular.element(document.querySelector("#payform"))
			# form[0].submit()
			
			# $log.log $("#merchantID").val()
			$timeout ()->
				# $log.log $("#merchantID").val()
				form= angular.element(document.querySelector("#payform"))
				form[0].submit()


angular.module("app") .controller 'payController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','utilService','growlService', '$window', '$http', PayController]
