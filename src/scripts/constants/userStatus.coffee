
UserStatus =
	EMAIL_VALIDATE		: 1 # 0001
	MOBILE_VALIDATE		: 2 # 0010
	IDENTITY_VALIDATE	: 4 # 0100
	FIRM_VALIDATE		: 8	# 1000


angular.module('app').constant 'userStatus', UserStatus
