class CashController
	constructor: (@$log,@$scope,@$state, @$stateParams,@ajaxService, @actionCode,@w5cValidator,@userSession,@$timeout,@utilService,@growlService) ->
		$scope.validateOptions =
			blurTrig: true

		initcash =() =>
			@cash =
				amount : angular.copy(null)
				kfname: angular.copy(null)
				bankName:angular.copy(null)
				bankBranch:angular.copy(null)
				cardNo:angular.copy(null)
				recardNo:angular.copy(null)
				counttype:angular.copy("1")
			@ajaxService.post actionCode.GET_USER,null
			.success (result)->
				$scope.money =result.money
				$scope.frozen=result.frozen
				$scope.overplus=result.money-result.frozen
			.error (error)->
				growlService.growl(error, 'danger')

		initcash()

		@addcash = (cash) ->
			cash.name =cash.kfname
			sheng = cash.city.cn[0] if cash.city.cn.length isnt 0
			city= cash.city.cn[1] if cash.city.cn.length isnt 0
			area= cash.city.cn[2] if cash.city.cn.length isnt 0
			cash.bankAddr = if sheng is undefined then '' else  sheng+'/'+city+'/'+area
			cash.type = parseInt cash.counttype
			if cash.bankAddr is ''
				growlService.growl("请选择开户行所在地！", 'danger')
				return
			cash.amount = cash.amount*100
			$log.log cash
			@ajaxService.post @actionCode.ACTION_DRAW_CASH, cash
			.success (result) =>
				$log.log result
				initcash()
				growlService.growl('提现申请已提交，请耐心等待,我们将在5个工作日内回款到您的帐户!', 'success')
				$state.go 'site.member.fundrecord'
			.error (error) =>
				cash.amount = cash.amount/100
				growlService.growl(error, 'danger')



angular.module("app") .controller 'cashController', ['$log','$scope','$state','$stateParams','ajaxService', 'actionCode','w5cValidator','userSession','$timeout','utilService','growlService', CashController]