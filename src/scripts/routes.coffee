class Config
	constructor: ($stateProvider, $urlRouterProvider, $injector) ->
		$stateProvider
			.state 'site',
				url: '/'
				abstract: true
				# templateUrl: 'views/base.html'
				template: '<ui-view/>'
				
			.state 'site.index',
				url: ''
				templateUrl: 'views/welcome2.html'

			.state 'site.login',
				url: 'login/:type'
				templateUrl: 'views/login.html'
						
			.state 'site.register',
				url: 'register/:type'
				templateUrl: 'views/register.html'

			.state 'site.register2',
				url: 'register-2'
				templateUrl: 'views/register-2.html'

			.state 'site.register3',
				url: 'register-3'
				templateUrl: 'views/register-3.html'

			.state 'site.register4',
				url: 'register-4'
				templateUrl: 'views/register-4.html'

			.state 'site.forgetpwd',
				url: 'forgetpwd'
				templateUrl: 'views/forgetpwd.html'

			.state 'site.permission-denied',
				url: 'permission-denied'
				templateUrl: 'views/permission-denied.html'

			# ########## member
			.state 'site.member',
				url: 'member/'
				abstract: true
				templateUrl: 'views/member.base.html'
				data:
					precondition: "requireLogin"
				
			.state 'site.member.index',
				url: ''
				templateUrl: 'views/user/index.html'

			# 我的发布
			.state 'site.member.issued',
				url: 'issued'
				templateUrl: 'views/user/issued.html'

			# 我的竞标, 我参与的
			.state 'site.member.participant',
				url: 'participant'
				templateUrl: 'views/user/participant.html'
	
			# 我的中标
			.state 'site.member.wonbid',
				url: 'wonbid'
				templateUrl: 'views/user/wonbid.html'

			.state 'site.member.delegationlist',
				url: 'delegationlist'
				templateUrl: 'views/user/delegationlist.html'

			.state 'site.member.addtransfer',
				url: 'addtransfer'
				templateUrl: 'views/user/addtransfer.html'

			.state 'site.member.createdebt',
				data:
					precondition: "requireCreateDebtValidate"

			.state 'site.member.createdebts',
				url: 'createdebts'
				templateUrl: 'views/user/createdebt.html'

			# 个人设置
			.state 'site.member.userinfo',
				url: 'userinfo'
				templateUrl: 'views/user/userinfo.html'

			.state 'site.member.userpwd',
				url: 'userpwd'
				templateUrl: 'views/user/userpwd.html'

			.state 'site.member.setting',
				url: 'setting'
				templateUrl: 'views/user/setting.html'

			.state 'site.member.authemail',
				url: 'authemail'
				templateUrl: 'views/user/authemail.html'
				data:
					precondition:
						require: 'requireHasEmail'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行邮箱验证"

			.state 'site.member.authmobile',
				url: 'authmobile'
				templateUrl: 'views/user/authmobile.html'
				data:
					precondition:
						require: 'requireHasMobile'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行手机验证"

			.state 'site.member.auth',
				data:
					precondition: "requireAuthValidate"

			.state 'site.member.authid',
				url: 'authid'
				templateUrl: 'views/user/authid.html'

			.state 'site.member.authids',
				url: 'authids'
				templateUrl: 'views/user/authids.html'

			.state 'site.member.authcompanys',
				url: 'authcompanys'
				templateUrl: 'views/user/authcompanys.html'

			.state 'site.member.authcompany',
				url: 'authcompany'
				templateUrl: 'views/user/authcompany.html'

			#财务管理
			.state 'site.member.pay',
				url: 'pay'
				templateUrl: 'views/user/pay.html'

			.state 'site.member.balance',
				url: 'balance'
				templateUrl: 'views/user/balance.html'

			.state 'site.member.cash',
				url: 'cash'
				templateUrl: 'views/user/cash.html'

			.state 'site.member.fundrecord',
				url: 'fundrecord'
				templateUrl: 'views/user/fundrecord.html'

			# ########## debt
			.state 'site.debt',
				url: 'debt/'
				abstract: true
				templateUrl: 'views/member.base.html'

			.state 'site.debt.list',
				url: ''
				templateUrl: 'views/debt/list.html'

			.state 'site.debt.detail',
				url: ':debtId'
				templateUrl: 'views/debt/detail.html'
				data:
					precondition: "requireIdentityValidate"

			# demo
			.state 'typography',
				url: '/typography',
				templateUrl: 'views/typography.html'
				

		$urlRouterProvider.otherwise '/'


angular.module('app').config ['$stateProvider', '$urlRouterProvider', '$injector', Config]
