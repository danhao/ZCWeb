
class Service

	constructor: (@$log, @messageService) ->

	isPhone: (value) ->
		# 校验手机号. 规则: 11位数字，以1开头
		return /^1\d{10}$/.test(value)

	isEmail: (value) ->
		#校验邮箱地址. 规则: 中间存在@, 前后为字母,_,.组成
		return /^(\w-*\.*)+@(\w\.*)+$/.test(value)


	formatTimeRange: (timeRange, format) ->
		# 将一个时间段,格式化为:年,月,日,时,分,秒
		# timeRange: 一个整形的时间段
		diff_day = timeRange / (24 * 60 * 60 * 1000)
		r = diff_day
		ret = {}
		
		y = Math.floor(r/365)
		ret['Y'] = y
		r = r - y * 365
		
		m = Math.floor r/30
		ret['M'] = m
		r = r - m * 30

		d = Math.floor(r)
		ret['d'] = d
		r = r - d

		r = r*24
		h = Math.floor r
		ret['H'] = h
		
		r = (r - h) * 60
		min = Math.floor r
		ret['m'] = min

		r = (r - min) * 60
		s = Math.floor r
		ret['s'] = s

		# format =
		ret

	#get time stamp
	gettimestamp : (datestr,type) ->
		date = new Date()
		datestr += " "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds() if type is 1
		result =Date.parse(datestr)/1000

	#get error msg
	geterrormsg :(error) ->
		msg = ""
		switch error.code
			when 104 then msg = "Email地址已存在！"
			when 105 then msg = "手机号码已存在！"
			when 106 then msg = "旧密码输入错误！"
			when 107 then msg = "手机验证失败！"
			when 108 then msg = "验证码不一致！"
			when 109 then msg = "权限不足！"
			else msg=error.desc

	###
	# 显示 alert 提示消息
	# type: 类型. 默认是 danger
	# timeout: 超时时间. -1表示不超时,一直显示; 默认为1s.
	###
	alert: (msg, type, timeout) ->
		@messageService.publish 'alert',
			type: type || 'danger'
			msg: msg
			timeout: timeout


angular.module('app').service 'utilService', ['$log', 'messageService', Service]
