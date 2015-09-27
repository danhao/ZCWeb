
class VOIP
	constructor: (@Cloopen, @voipId, @$log, @$scope, @$interval) ->
		# @$log.log 'voip'
		@configuration()

		# init vars
		@log = ""
		@cloopenInited = false
		@c = 0					# 计时器
		@timer = null
		@timeStr = "00:00"
		@step = 'step1'

		@steps = ['step1', 'step2', 'step3', 'step4']
		
		# @updateLog "您的voip子账号为："+@voipObj[@voipId]
		@updateLog "你的token为:"+@tokenObj[@voipId]
		@updateLog "你的应用ID为:"+@appid
		@coolpen_init()
		

	configuration: =>
		@appid = '8a48b5514fba2f87014fc0a3b47710a3'
		@tokenObj =
			'token1':'641899824160968705'
		
		# 配置voip账号和密码
		# 配置voip子账号，部署到web服务器后，通过URL/index.html?id=voip1的方式来登录第一个voip子账号，登录其他子账号以此类推
		# @voipObj =
		# 	'voip1':'8000664700000001'
		# 	'voip2':'8000664700000002'
		# 	'voip3':'8000664700000003'
		# 	'voip4':'8000664700000004'
		# 	'voip5':'8000855400000001'
		#可根据需要继续添加子账号

		# 配置voip子账号的密码，子账号要与voipObj中的一致。
		# @passwdObj =
		# 	'8000664700000001':'8zjuo64i'
		# 	'8000664700000002':'m0zgflrd'
		# 	'8000664700000003':'lg5wdsjz'
		# 	'8000664700000004':'47n1giht'
		# 	'8000855400000001':'l5smzpvl'
		# 可根据需要继续添加

	updateLog: (msg)=>
		# @log += "<p>#{msg}</p>"
		@$log.log msg

	timeCount: () =>
		@timer = @$interval ()=>
			@c = @c + 1
			minute = parseInt(@c/60%60)
			second = parseInt(@c%60)
			mstr = if minute < 10 then "0#{minute}" else minute
			sstr = if second < 10 then "0#{second}" else second
			@timeStr = "#{mstr}:#{sstr}"
		, 1000

	stopCount: =>
		@$interval.cancel @timer
		@c = 0
		@timeStr = "00:00"

	coolpen_init: ()=>
		# @$log.log 'Cloopen'
		# @$log.log @$window.Cloopen
		@Cloopen.debug()
		@Cloopen.forceLogin()
		# @Cloopen.initByUser(
		# 	'idvideophone', 	# swf对应的id
		# 	@initCallback,		# 初始化时自定义 fun
		# 	@notifyCallback, 	# 显示通知的自定义 fun
		# 	@voipId, 			# voip子账号
		# 	@passwdObj[@voipObj[@voipId]] # voip子账号密码
		# )
		# @Cloopen.initByUser('idvideophone',@initCallback,@notifyCallback,@voipId,@passwdObj[@voipObj[@voipId]])

		@Cloopen.init('idvideophone', @initCallback, @notifyCallback, @appid+'#'+@tokenObj[@voipId])
			
		# 未连接状态
		@Cloopen.when_idle ()=> @updateLog "未连接..."
		# 正在连接服务器注册
		@Cloopen.when_connecting ()=> @updateLog "正在连接服务器注册..."
		# 已经注册登录
		@Cloopen.when_connected ()=>
			@cloopenInited = true
			@$scope.$apply ()=>
				@step = 'step1'
		# 正在呼出
		@Cloopen.when_outbound ()=>
			@updateLog "正在呼出..."
			@$scope.$apply ()=>
				@step = 'step3'
		# 有呼入
		@Cloopen.when_inbound ()=>
			@updateLog "有电话呼入..."
			@$scope.$apply ()=>
				@step = 'step2'
		# 通话中
		@Cloopen.when_active ()=>
			@updateLog "通话中..."
			@stopCount()
			@timeCount()
			@$scope.$apply ()=>
				@step = 'step4'

	notifyCallback: (doFun, msg)=>
		switch doFun
			when "invited" then @updateLog "发起呼叫成功事件"
			when "invitefailed" then @updateLog "发起呼叫失败事件"
			when "accepted" then @updateLog "对端应答事件"
			when "ringing" then @updateLog "来电事件，号码:#{msg}"
			when "onHangup"
				switch msg
					when "normal" then @updateLog "挂机事件: 本端正常挂机"
					when "byed" then @updateLog "挂机事件: 对端正常挂机"
					when "rejected" then @updateLog "挂机事件: 对端拒接"
					when "unallocated" then @updateLog "挂机事件: 呼叫号码为空号"
					when "noresponse" then @updateLog "挂机事件: 呼叫无响应"
					when "noanswer" then @updateLog "挂机事件: 对方无应答"
					else @updateLog "挂机事件: #{msg}"
			else @updateLog msg	# 其他未知事件


	initCallback: () =>
		@$log.log 'init callback'
		@cloopenInited = true

	# 发起 voip 呼叫
	voipcall: () =>
		@$log.log 'voip call'
		unless @cloopenInited
			return
		@updateLog "VoIP呼出: #{@voipId}"
		@Cloopen.invitetel @voipId

	# 发起落地呼叫
	landcall: () =>
		@$log.log 'land call'
		unless @cloopenInited
			return
		phone = @$scope.phone
		@updateLog "落地呼出：#{phone}"
		@Cloopen.invitetel.bind(@Cloopen) phone
		
	# 挂断
	stopcall: () =>
		@$log.log 'stop call'
		unless @cloopenInited
			return
		@Cloopen.bye()
		@stopCount()
		@step = 'step1'

	# 接听
	accept: =>
		unless @cloopenInited
			return
		@Cloopen.accept()
		@step = 'step4'

	reject: =>
		unless @cloopenInited
			return
		@Cloopen.reject()
		@step = 'step1'

	xxx: =>
		@step = 'step4'



class Directive
	constructor: ($log, $window, $interval) ->
		link = (scope, elem, attrs)->
			$log.log "voip directive."
			scope.voip = new VOIP $window.Cloopen, 'token1', $log, scope, $interval
		
		return {
			# replace: true
			restrict: 'AE'
			scope:
				phone: '='
				disabled: '@'
				includeFlash: '@'
			templateUrl: '/views/directives/voip.html'
			link: link
		}

angular.module('app').directive 'voip', ['$log', '$window', '$interval', Directive]

