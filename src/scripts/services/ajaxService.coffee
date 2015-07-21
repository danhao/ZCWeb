
add_success_and_error_support_in_promise = (promise, errorCode) ->
	promise.success = (fn) ->
		promise.then (response) ->
			# return result set to client
			ret =
				try
					angular.fromJson response.data.rsp
				catch error
					response.data.rsp
			fn ret, response.status, response.headers, response.config, response.data
		promise

	promise.error = (fn) ->
		promise.then null, (response) ->
			# return the error object to client
			fn errorCode[response.data.error], response.status, response.headers, response.config, response.data
		promise


class Service
	# url = 'http://127.0.0.1:30001/'
	
	constructor: (@$log, @$http, @$q, @errorCode, @configuration, @userSession) ->
		@url = @configuration['APP_SERVER_URL']

	ajax: (method, code, data) ->
		deferred = @$q.defer()
		
		params =
			code: code
			req: data
		if @userSession.pid()
			params['pid'] = @userSession.pid()
		if @userSession.sid()
			params['sid'] = @userSession.sid()
			
		@$http[method] @url, params
		.then(
			((response) ->
				data = response.data
				if data.error == 0
					deferred.resolve response
				else
					deferred.reject response
			), ((result) ->
				deferred.reject result
			))
		promise = deferred.promise
		add_success_and_error_support_in_promise promise, @errorCode
		promise
		
	get: (code, data) ->
		@ajax 'get', code, data

	post: (code, data) ->
		@ajax 'post', code, data

	put: (code, data) ->
		@ajax 'put', code, data

	delete: (code, data) ->
		@ajax 'delete', code, data


angular.module('app').service 'ajaxService', ['$log', '$http', '$q', 'errorCode', 'configuration', 'userSession', Service]

