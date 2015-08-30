
class TestController
	constructor: (@$log, @$rootScope, @userSession) ->
		@$log.log 'test controller'
		ossInfo = @$rootScope.ossInfo
		pid = @userSession.pid()
		url = ossInfo.url
		data =
			OSSAccessKeyId: ossInfo.ossId
			policy: ossInfo.policy
			signature: ossInfo.signature
			key: "#{pid}/abc1235.png"
		@flow = new Flow
			target: url
			query: data
			testMethod: false
		@$log.log @flow


angular.module('app').controller 'testController', ['$log', '$rootScope', 'userSession', TestController]

