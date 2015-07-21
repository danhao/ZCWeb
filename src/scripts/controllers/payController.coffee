class PayController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService) ->
		$scope.validateOptions =
			blurTrig: true

		$scope.closeAlert = (index)->
			$scope.alerts.splice(index, 1)

		payinfo =
			version:"v1.0"
			language : "1"
			inputCharset : "1"
			pickupUrl: "http://203.195.133.243/#/member/"
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
			payinfo.orderAmount = (money*100).toString()
			@ajaxService.post @actionCode.ACTION_CREATE_ORDER, payinfo
			.success (result) =>
				$log.log result
				submit(result)
			.error (error) =>
				alert('danger',error)

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



#			return
#			@payService.submit(@pay)

		alert = (type,msg) ->
			$scope.alerts=[
				type :type
				msg: msg
			]
			$timeout ()=>
				$scope.closeAlert 0
			,2*1000
			$log.log type



angular.module("app") .controller 'payController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','utilService', PayController]