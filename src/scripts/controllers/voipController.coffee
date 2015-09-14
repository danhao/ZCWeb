
class VOIPController
	constructor: (@$log, @$stateParams, @$window) ->
		# @$log.log 'voip'
		@configuration()
		@voipId = @$stateParams.id
		@log = ""
		@updateLog "您的voip子账号为："+@voipObj[@voipId]
		@coolpen()
		

	configuration: ->
		# 配置voip账号和密码
		# 配置voip子账号，部署到web服务器后，通过URL/index.html?id=voip1的方式来登录第一个voip子账号，登录其他子账号以此类推
		@voipObj = 
			'voip1':'8000664700000001'
			'voip2':'8000664700000002'
			'voip3':'8000664700000003'
			'voip4':'8000664700000004'
			'voip5':'8000664700000005'
		#可根据需要继续添加子账号

		# 配置voip子账号的密码，子账号要与voipObj中的一致。
		@passwdObj = 
			'8000664700000001':'8zjuo64i'
			'8000664700000002':'m0zgflrd'
			'8000664700000003':'lg5wdsjz'
			'8000664700000004':'47n1giht'
			'8000664700000005':'vgyedt9k'
		# 可根据需要继续添加

	updateLog: (msg)->
		@log += "<p>#{msg}</p>"

	coolpen: ()->
		@$log.log 'Cloopen'
		@$log.log @$window.Cloopen
	
	

angular.module('app').controller 'voipController', ['$log', '$stateParams', '$window', VOIPController]

		
