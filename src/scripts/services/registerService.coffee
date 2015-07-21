class RegisterService
	url = 'http://127.0.0.1:30001/'

	constructor: (@$log, @$http) ->

	register: (user) ->
		data =
			code: 2
			req: user
		@$http.post("#{url}", data)
		.error (results, status) ->
			{results, status}

			
angular.module('app').service 'registerService', ['$log', '$http', RegisterService]
