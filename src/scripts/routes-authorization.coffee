
###
与 ui-router 结合使用进行权限验证.
在 state 的配置中加入 precondition 参数. 该参数必须放在 data 中.

usage:
1.
`
			.state 'site.member',
				url: 'member/'
				templateUrl: 'views/member.base.html'
				data:
					precondition: "requireLogin"
`

2.
`
			.state 'site.member.authemail',
				url: 'authemail'
				templateUrl: 'views/user/authemail.html'
				data:
					precondition:
						require: ->
							# 判断邮箱是否已填写
							false
						redirectTo: "site.member.userinfo"
						msg: "你需要先完善个人信息,再进行邮箱验证"
`

说明:
1. precondition参数, 可以一个的字符串(假设为 abc). 如果是字符串,其验证规则及重定向逻辑,在 Authorization 中定义.
	查找的逻辑是, 在 Authorization 中查找该同名(abc)的成员函数作为其验证规则.
	查找该字符串+'Redirect'函数(即 abcRedirect )的返回值作为重定向的目标.
	
2. precondition参数, 也可以是一个对象. 如果是对象, 你可以提供以下3个参数:
	- require : 提供验证的逻辑
	- redirectTo: 重定向目标
	- msg: 验证不通过,给用户的提示信息.

###
class Authorization
	constructor: (@$log, @$rootScope, @$q, @$timeout, @$state, @$stateParams, @userSession, @utilService, @ajaxService, @actionCode, @userStatus, @$location,@growlService) ->
		@$rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) =>

			# trick to workaround the infinit loop issue
			if toState.$$finishAuthorize
				return

			# track the state the user wants to go to;
			@$rootScope.toState = toState
			@$rootScope.fromState = fromState
			@$rootScope.toParams = toParams

			# require precondition
			if toState.data and toState.data.precondition
				event.preventDefault()
				toState = angular.extend {'$$finishAuthorize': true}, toState # trick to workaround the infinit loop issue

				precondition = toState.data.precondition
				cond = if angular.isObject(precondition) then precondition.require else precondition
				if angular.isString(cond)
					satisfiedFun = @[cond]()
				else if angular.isFunction(cond)
					satisfiedFun = cond()
				else
					throw new Error("only string or function supported for precondition")

				# redirect function
				redirect = (ret) =>
					if precondition.redirectTo
						redirectTo = precondition.redirectTo
						redirectTo = redirectTo(ret) if angular.isFunction(redirectTo)
					else if @[cond+'Redirect']
						redirectTo = @[cond+'Redirect'](ret)
					else # send user back to the original page
						# redirectTo = @permissionDeniedRedirect()
						redirectTo = fromState.name

					if precondition.msg
#						@utilService.alert precondition.msg, "info"
						@gotoUserinfo(precondition.msg)
					
					@$state.go redirectTo, toParams

				# authorization
				satisfiedFun.then (ret) =>
					if ret # satisfy precondition, continue
						# trick to workaround the infinit loop issue
						@$state.go toState.name, toParams, {notify: false}
							.then ()=>
								@$rootScope.$broadcast '$stateChangeSuccess', toState, toParams, fromState, fromParams
					else
						redirect(ret)
				, (e)->
					redirect(e)

					
		@requireLogin = () =>
			@$q.when @userSession.pid()

		@requireLoginRedirect = () =>
			@growlService.growl "您尚未登陆, 无权限查看此页面!", 'warning'
			"site.index"

		@permissionDeniedRedirect = () ->
			"site.permission-denied"

		@getUser = (callback) =>
			defered = @$q.defer()
			@ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}
				.success (user) =>
					@user = user
					defered.resolve callback(user)
				.error (error) ->
					defered.reject false
			defered.promise

		@gotoUserinfo = (msg ,state)=>
			@growlService.growl(msg, 'warning')
			state

		@requireIdentityValidated = () =>
			@getUser (user) ->
				status = user.status
				(status&userStatus.EMAIL_VALIDATE)==1 or (status&userStatus.MOBILE_VALIDATE)==2 or (status&userStatus.IDENTITY_VALIDATE)==4 or (status&userStatus.FIRM_VALIDATE)==8

		@requireHasEmail = () =>
			@getUser (user) ->
				!!user.email
			# defered = @$q.defer()
			# @getUser().success (user) -> defered.resolve !!user.email
			# 	.error (error) -> defered.reject false
			# defered.promise

		@requireHasMobile = () =>
			@getUser (user) ->
				!!user.mobile
			# defered = @$q.defer()
			# @getUser().success (user) -> defered.resolve !!user.mobile
			# 	.error (error) -> defered.reject false
			# defered.promise

		@requireUserInfo = () =>
			@getUser (user) ->
				!!user.email and !!user.mobile
			# defered = @$q.defer()
			# @getUser().success (user) -> defered.resolve (!!user.email and !!user.mobile)
			# 	.error (error) -> defered.reject false
			# defered.promise

		# @getUser = ()=> @ajaxService.post @actionCode.GET_USER, {id: @userSession.pid()}



authorization = ($log, $rootScope, $q, $timeout, $state, $stateParams, userSession, utilService, ajaxService, actionCode, userStatus, $location,growlService) ->
	new Authorization $log, $rootScope, $q, $timeout, $state, $stateParams, userSession, utilService, ajaxService, actionCode, userStatus, $location,growlService


angular.module('app').run ['$log', '$rootScope', '$q', '$timeout', '$state', '$stateParams', 'userSession', 'utilService', 'ajaxService', 'actionCode', 'userStatus', '$location','growlService', authorization]

