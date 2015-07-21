
class UserSession
	constructor: (@$cookies, @$rootScope) ->

	pid: () ->
		if not @_pid
			@_pid = @$cookies.get "pid"
		@_pid
			
	sid: () ->
		if not @_sid
			@_sid = @$cookies.get "sid"
		@_sid

	store: (@_pid, @_sid, opt) ->
		@$cookies.put "pid", @_pid, opt
		@$cookies.put "sid", @_sid, opt

	clear: () ->
		@$cookies.remove "pid"
		@$cookies.remove "sid"
		@_pid = null
		@_sid = null
	
		
angular.module('app').service 'userSession', ['$cookies', '$rootScope', UserSession]
