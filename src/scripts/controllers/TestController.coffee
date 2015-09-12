
class TestController
	constructor: (@$log, @$rootScope, @userSession) ->
		@$log.log 'test controller'
		pid = @userSession.pid()
		# ossInfo = @$rootScope.ossInfo
		# url = ossInfo.url
		# data =
		# 	OSSAccessKeyId: ossInfo.ossId
		# 	policy: ossInfo.policy
		# 	signature: ossInfo.signature
		# 	key: "#{pid}/aaa.jpg"
		# @$log.log url
		# @$log.log data
		# @flow = new Flow
		# 	target: url
		# 	query: data
		# 	testMethod: false
		# @$log.log @flow

		# u =
		# 	head: [
		# 		name: "avatar-2.jpg"
		# 		id: "637061014470266881/f5e3e26e-a2e9-f469-e7ef-45efa681e4ab.jpg"
		# 		url: "https://zichan.oss-cn-shenzhen.aliyuncs.com/637061014470266881/f5e3e26e-a2e9-f469-e7ef-45efa681e4ab.jpg?OSSAccessKeyId=1P160AxzpPoOG6Ej&Signature=nsTNkfgpmGjZ2g7CTqQ5rdeg5zs%3D&Expires=1442047985"
		# 	]
		
		
		# @$timeout ()->
		# 	@user = u
		# , 100


angular.module('app').controller 'testController', ['$log', '$rootScope', 'userSession', TestController]

