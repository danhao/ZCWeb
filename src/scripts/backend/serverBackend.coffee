class Run
	constructor: (@$log, @$httpBackend) ->
		@$httpBackend.whenGET(/127.0.0.1:30001/).passThrough()
		@$httpBackend.whenPOST(/127.0.0.1:30001/).passThrough()
		@$httpBackend.whenPOST(/aliyuncs.com/).passThrough()
		@$httpBackend.whenPOST(/allinpay.com/).passThrough()
		@$httpBackend.whenPOST(/gateway.gopay.com.cn/).passThrough()

angular.module('app').run ['$log', '$httpBackend', Run]
