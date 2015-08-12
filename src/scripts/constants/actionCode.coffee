
ActionCode = # do () ->
	LOGIN						: 1		# 登陆
	CREATE_USER					: 2		# 注册
	GET_USER					: 3		# 获取用户
	VALIDATE_EMAIL_MOBILE		: 4 	# 验证用户
	# VALIDATE_EMAIL			:  5 	# 验证Email(null---->null)
	# UPDATE_USER				:  6 	# 更新用户(player.UpdateReq---->null)
	# SEND_MOBILE_CODE			:  7	# 发短信验证码(null---->null)
	# VALIDATE_MOBILE			:  8	# 验证手机(player.ValidateMobileReq---->null)
	# CHANGE_PWD_ONE			:  9	# 重置密码第一步(player.ChangePwdReq---->null)
	# CHANGE_PWD_TWO			:  10	# 重置密码第二步(player.ChangePwdReq---->null)
	ACTION_VALIDATE_EMAIL		: 5 #验证Email
	ACTION_UPDATE_USER			: 6     #更新用户
	ACTION_SEND_MOBILE_CODE		: 7  #发短信验证码
	ACTION_VALIDATE_MOBILE		: 8   #验证手机
	ACTION_CHANGE_PWD_ONE		: 9    #重置密码第一步
	ACTION_CHANGE_PWD_TWO		:10		#重置密码第二步
	ACTION_CHANGE_PWD_THREE		:11 	#重置密码第三步
	ACTION_GET_OTHER			:12 #查看他人(common.SingleMsg---->player.SimplePlayerMsg)
	ACTION_LIST_MONEY_HISTORY	:13 #查看资金使用情况(player.ListMoneyHistoryReq---->player.ListMoneyHistoryRsp)
	ACTION_LIST_SITUAION		: 14 		#查看动态(null---->player.ListSituationRsp)
	ACTION_SET_ALERT			: 16			# 提醒设置
	ACTION_BUY_VIP				:17 #购买VIP(common.SingleMsg(VIP等级)---->null)
	ACTION_UPLOAD				:18 #上传文件(common.FileMsg---->player.PlayerMsg)
	ACTION_DEBT_COUNT			: 19 		# 还能接单的数量(null---->common.SingleMsg)
	UPLOAD_PREPARE				: 51	# 准备上传文件
	
	CREATE_DEBT					: 100	# 创建债务
	LIST_DEBTS					: 101	# 债务列表
	VIEW_DEBT					: 102	# 债务明细
	ACTION_LIST_VIEW_DEBTS		: 103	# 首页债务列表
	ACTION_BID					: 104 	# 投标(debt.BidReq---->null)
	ACTION_BID_WIN				: 105	# 中标(debt.BidWinReq---->debt.DebtMsg)
	ACTION_ADD_MESSAGE			: 106	# 增加动态(debt.MessageMsg---->null)
	ACTION_LIST_SELF_DEBTS		: 107 #我相关的债务
	ACTION_CREATE_ORDER			: 200		# 创建订单(pay.CreateOrderReq---->pay.CreateOrderRsp)
	ACTION_DRAW_CASH			: 201 		# 提现申请(pay.PlayerCashMsg---->null)
	ACTION_BATCH_BID			: 108 		# 批量投标(debt.BatchBidReq---->null)
	ACTION_RETURN_DEBT			: 109 		# 退单(common.SingleMsg---->null)
	ACTION_APPLY_END_DEBT		: 110		# 申请结单(common.SingleMsg---->null)



angular.module('app').constant 'actionCode', ActionCode
