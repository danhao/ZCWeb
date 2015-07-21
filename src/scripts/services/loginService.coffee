class LoginService
	urlBase = 'http://127.0.0.1:30001/'
	
	constructor: (@$log, @$http) ->
		
	# {"code":1,"data":["username","emial","mobile","passwd"]}
	login: (identity, password) ->
		data = {code: 1}
		req = ['']
		if (identity.indexOf "@") > 0
			req.push(identity)
			req.push('')
		else
			req.push('')
			req.push(identity)
		req.push(password)
		data['req'] = req
		@$log.log data
		
		@$http.post("#{urlBase}", data)
			.success (results) ->
				results
			.error (results, status) ->
				{results, status}
		


angular.module("app").service 'loginService', ['$log', '$http', LoginService]
