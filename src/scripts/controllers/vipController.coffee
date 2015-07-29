class VipController
	constructor: (@$log,@$scope, @actionCode, @ajaxService, @userSession,@$state, @$stateParams,@growlService) ->
		@pid = @userSession.pid()
		@VipMoney =500
		@ajaxService.post @actionCode.GET_USER, {id: @pid}
		.success (result) =>
			@user=result
		.error (error) =>
			growlService.growl(error.desc, 'danger')

		@ok=()->
			@ajaxService.post @actionCode.ACTION_BUY_VIP, {param: @user.type.toString()}
			.success (result) =>
				@hidebuyvipModal()
				growlService.growl('VIP会员服务购买成功！', 'success')
			.error (error) =>
				@hidebuyvipModal()
				growlService.growl(error.desc, 'danger')

		@buypersonVip=() ->
			@VipMoney =500
			if @user.type is 1
				growlService.growl('企业催收用户不能购买个人催收VIP会员服务！', 'warning')
				return

			if @user.vip > 0
				growlService.growl('您已经购买了VIP会员服务！', 'warning')
				return
			@openbuyvipModal()

		@buycompanyVip=() ->
			@VipMoney =20000
			$log.log @VipMoney
			if @user.type is 0
				growlService.growl('个人催收用户不能购买企业催收VIP会员服务！', 'warning')
				return

			if @user.vip > 0
				growlService.growl('您已经购买了VIP会员服务！', 'warning')
				return
			@openbuyvipModal()

	openbuyvipModal: ->
		angular.element "#buyvipModal"
		.modal()
		true

	hidebuyvipModal:->
		angular.element "#buyvipModal"
		.one 'hidden.bs.modal', (e) =>
			@$state.go 'site.member.vip'
		.modal "hide"
		true

	recharge: ->
		angular.element "#buyvipModal"
		.one 'hidden.bs.modal', (e) =>
			@$state.go 'site.member.pay'
		.modal "hide"
		true



angular.module('app')
				.controller 'vipController', ['$log','$scope', 'actionCode', 'ajaxService', 'userSession','$state','$stateParams','growlService', VipController]