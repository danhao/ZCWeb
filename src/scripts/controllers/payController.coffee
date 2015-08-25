class PayController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService,@growlService) ->
		$scope.validateOptions =
			blurTrig: true


		payinfo =
			version:"v1.0"
			language : "1"
			inputCharset : "1"
			# pickupUrl: "http://203.195.133.243/#/member/"
			pickupUrl: "http://ddzhai.cn/#/member/"
			payType :  "0"
			signType : "1"
			orderAmount:"0"
			orderCurrency :  "0"
			orderExpireDatetime :  "60"
			payerTelephone :  ""
			payerEmail :  ""
			payerName :  ""
			payerIDCard :  ""
			pid:  ""
			productName:  ""
			productId :  ""
			productNum :  ""
			productPrice :  ""
			productDesc:  ""
			ext2 :  ""
			extTL :  ""
			issuerId:  ""
			pan:  ""
			tradeNature:  ""


		@pay=(money)->
			if money>10000000
				growlService.growl("充值金额不能大于1000万元！", 'danger')
				return
			payinfo.orderAmount = (money*100).toString()
			@ajaxService.post @actionCode.ACTION_CREATE_ORDER, payinfo
			.success (result) =>
				$log.log result
				submit(result)
			.error (error) =>
				growlService.growl(error.desc, 'danger')

		submit =(payrsp) ->
			$scope.pay =
				orderAmount:payinfo.orderAmount
				inputCharset:payinfo.inputCharset
				pickupUrl:payinfo.pickupUrl
				receiveUrl:payrsp.receiveUrl
				language : payinfo.language
				signType : payinfo.signType
				version : payinfo.version
				merchantId:payrsp.merchantId
				payerName:payinfo.payerName
				payerEmail:payinfo.payerEmail
				payerTelephone:payinfo.payerTelephone
				payerIDCard:payinfo.payerIDCard
				pid:payinfo.pid
				orderNo:payrsp.orderNo
				orderCurrency:payinfo.orderCurrency
				orderDatetime:payrsp.orderDatetime
				orderExpireDatetime:payinfo.orderExpireDatetime
				productName:payinfo.productName
				productPrice:payinfo.productPrice
				productNum:payinfo.productNum
				productId:payinfo.productId
				productDesc:payinfo.productDesc
				ext1:payrsp.ext1
				ext2:payinfo.ext2
				payType:payinfo.payType
				issuerId:payinfo.issuerId
				pan:payinfo.pan
				tradeNature:payinfo.tradeNature
				signMsg:payrsp.signMsg
#			document.getElementById("payform").submit()
			form= angular.element(document.querySelector("#payform"))
			$scope.$apply()
			form[0].submit()






angular.module("app") .controller 'payController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','utilService','growlService', PayController]
