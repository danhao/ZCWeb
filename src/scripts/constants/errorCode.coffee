
ErrorCode =
	# 系统相关错误码
	1:
		code: 1
		name: "ERR_SYSTEM"
		desc: "系统异常"
	2:
		code: 2
		name: "ERR_UNKNOWN"
		desc: "未知错误"
	3:
		code: 3
		name: "ERR_PARAMETER"
		desc: "错误的参数"
	4:
		code: 4
		name: "ERR_NET_TIMEOUT"
		desc: "网络超时"
	5:
		code: 5
		name: "ERR_PLATFORM_INVALID"
		desc: "平台校验无效"
	6:
		code: 6
		name: "ERR_ILLEGAL_REQUEST"
		desc: "非法请求"
	7:
		code: 7
		name: "ERR_MAINTAIN"
		desc: "服务器维护中"
	8:
		code: 8
		name: "ERR_MAX_ONLINE"
		desc: "最大在线人数"
	9:
		code: 9
		name: "ERR_OTHER_LOGIN"
		desc: "异地登陆"
	10:
		code: 10
		name: "ERR_SERVER_STOPPING"
		desc: "停服中"

	# 玩家相关错误码
	100:
		code: 100
		name: "ERR_ACCOUNT_FORBIDDEN"
		desc: "封号"
	101:
		code: 101
		name: "ERR_LOGOUT"
		desc: "登出"
	102:
		code: 102
		name: "ERR_NO_MONEY"
		desc: "游戏币不足"
	103:
		code: 103
		name: "ERR_NO_PLAYER"
		desc: "用户不存在或密码错误"
	104:
		code: 104
		name: "ERR_EMAIL_EXIST"
		desc: "存在email"
	105:
		code: 105
		name: "ERR_MOBILE_EXIST"
		desc: "存在mobile"
	106:
		code: 106
		name: "ERR_PASSWD_NOT_SAME"
		desc: "密码不一致"
	107:
		code: 107
		name: "ERR_MOBILE_FAILED"
		desc: "手机验证失败"
	108:
		code: 108
		name: "ERR_CODE_FAILED"
		desc: "验证码不一致"
	109:
		code: 109
		name: "ERR_AUTHORIZED_FAILED"
		desc: "权限不足"

	# 债务相关错误码
	200:
		code: 200
		name: "ERR_DEBT_INVALID"
		desc: "非法单"
	201:
		code: 201
		name: "ERR_DEBT_BID_LOW"
		desc: "投标金额不足"
	202:
		code: 202
		name: "ERR_DEBT_EXPIRED"
		desc: "过期"
	203:
		code: 203
		name: "ERR_DEBT_NO_CORP"
		desc: "用户不能接企业单"
	204:
		code: 204
		name: "ERR_DEBT_OVER_LIMIT"
		desc: "超过单数限制"


angular.module("app").constant 'errorCode', ErrorCode
