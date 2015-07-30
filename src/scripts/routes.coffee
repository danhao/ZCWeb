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

			.state 'site.agreement',
				url: 'agreement'
				templateUrl: 'views/agreement.html'

			# ########## member
			.state 'site.member',
				url: 'member/'
				abstract: true
				templateUrl: 'views/member.base.html'
				data:
					precondition: "requireLogin"
					breadcrumbProxy: 'site.member.index'
				
			.state 'site.member.index',
				url: ''
				templateUrl: 'views/user/index.html'
				data:
					displayName: "个人中心"

			.state 'site.profile',
				url: ''
				abstract: true
				templateUrl: 'views/member.base.html'

			.state 'site.profile.profile',
				url: 'profile/:Id'
				templateUrl: 'views/user/profile.html'
				data:
					displayName: "个人详细信息"

			# 我的发布
			.state 'site.member.issued',
				url: 'issued'
				templateUrl: 'views/user/issued.html'
				data:
					displayName: "我的委托"

			# 我的竞标, 我参与的
			.state 'site.member.participant',
				url: 'participant'
				templateUrl: 'views/user/participant.html'
				data:
					displayName: "我的竞标"
	
			# 我的中标
			.state 'site.member.wonbid',
				url: 'wonbid'
				templateUrl: 'views/user/wonbid.html'
				data:
					displayName: "我的中标"

			.state 'site.member.delegationlist',
				url: 'delegationlist'
				templateUrl: 'views/user/delegationlist.html'

			.state 'site.member.addtransfer',
				url: 'addtransfer'
				templateUrl: 'views/user/addtransfer.html'

			.state 'site.member.createdebt',
				url: 'createdebt'
				templateUrl: 'views/user/createdebt.html'
				data:
					precondition:
						require: "requireCreateDebtValidate"
						redirectTo: "site.member.index"
						msg: "您需要先验证(手机,邮箱,身份)其中之一,才能发布债权信息"
					displayName: "发布债权"

			# 个人设置
			.state 'site.member.userinfo',
				url: 'userinfo'
				templateUrl: 'views/user/userinfo.html'
				data:
					displayName: "基本信息"

			.state 'site.member.userpwd',
				url: 'userpwd'
				templateUrl: 'views/user/userpwd.html'
				data:
					displayName: "修改密码"

			.state 'site.member.setting',
				url: 'setting'
				templateUrl: 'views/user/setting.html'

			.state 'site.member.authemail',
				url: 'authemail'
				templateUrl: 'views/user/authemail.html'
				data:
					displayName: "邮箱验证"
					precondition:
						require: 'requireHasEmail'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行邮箱验证"

			.state 'site.member.authmobile',
				url: 'authmobile'
				templateUrl: 'views/user/authmobile.html'
				data:
					displayName: "手机验证"
					precondition:
						require: 'requireHasMobile'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行手机验证"

			.state 'site.member.notifySetting',
				url: 'notify'
				templateUrl: 'views/user/notifySetting.html'
				data:
					displayName: "设置"

			.state 'site.member.auth',
				url: 'auth'
				resolve:
					user: ['userSession', 'ajaxService', 'actionCode', '$log', (userSession, ajaxService, actionCode, $log) ->
						pid = userSession.pid()
						ajaxService.post actionCode.GET_USER, {id: pid}
							.then (rsp) ->
								return angular.fromJson rsp.data.rsp
					]
					
				controller: ['$log', '$state', 'userStatus', 'user', ($log, $state, userStatus, user) ->
#					 $log.log user.type
					# status&userStatus.IDENTITY_VALIDATE==0
					if user.type is 0
						if user.idValidating is 1 or user.state & userStatus.IDENTITY_VALIDATE is 1 # 个人身份认证
							$state.go 'site.member.authids'
						else
							$state.go 'site.member.authid'
					else
						if user.coValidating is 1 or user.state & userStatus.FIRM_VALIDATE is 1 # 企业身份认证
							$state.go 'site.member.authcompanys'
						else
							$state.go 'site.member.authcompany'
				]

			.state 'site.member.authid',
				url: 'authid'
				templateUrl: 'views/user/authid.html'
				data:
					displayName: "个人验证"
					precondition:
						require: 'requireUserInfo'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行身份验证"

			.state 'site.member.authids',
				url: 'authids'
				templateUrl: 'views/user/authids.html'
				data:
					displayName: "个人验证资料展示"

			.state 'site.member.authcompanys',
				url: 'authcompanys'
				templateUrl: 'views/user/authcompanys.html'
				data:
					displayName: "企业验证"

			.state 'site.member.authcompany',
				url: 'authcompany'
				templateUrl: 'views/user/authcompany.html'
				data:
					displayName: "企业验证资料展示"
					precondition:
						require: 'requireUserInfo'
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行身份验证"

			#财务管理
			.state 'site.member.pay',
				url: 'pay'
				templateUrl: 'views/user/pay.html'
				data:
					displayName: "我要充值"

			.state 'site.member.balance',
				url: 'balance'
				templateUrl: 'views/user/balance.html'

			.state 'site.member.cash',
				url: 'cash'
				templateUrl: 'views/user/cash.html'
				data:
					displayName: "我要提现"

			.state 'site.member.fundrecord',
				url: 'fundrecord'
				templateUrl: 'views/user/fundrecord.html'
				data:
					displayName: "资金记录"

			.state 'site.member.vip',
				url: 'vip'
				templateUrl: 'views/user/vip.html'
				data:
					displayName: "购买VIP会员服务"

			# ########## debt
			.state 'site.debt',
				url: 'debt/'
				abstract: true
				templateUrl: 'views/member.base.html'
				data:
					breadcrumbProxy: 'site.debt.list'

			.state 'site.debt.list',
				url: ''
				templateUrl: 'views/debt/list.html'
				data:
					displayName: '债务列表'

			.state 'site.debt.detail',
				url: ':debtId'
				templateUrl: 'views/debt/detail.html'
				data:
					precondition:
						require: 'requireIndentity'
						msg: "你需要身份认证之后,才允许查看"
					displayName: '债务明细'


			# demo
			.state 'typography',
				url: '/typography',
				templateUrl: 'views/typography.html'

			.state 'site.test',
				url: 'test',
				templateUrl: 'views/test.html'
				

		$urlRouterProvider.otherwise '/'


angular.module('app').config ['$stateProvider', '$urlRouterProvider', '$injector', Config]
