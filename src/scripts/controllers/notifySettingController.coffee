class NotifySettingController

	constructor: (@$log) ->
		@$log.log 'init controller'
		
	save: (form, setting) ->
		@$log.log setting

	enableNotify: () ->
		@$log.log @setting.enable


angular.module("app").controller "notifySettingController", ['$log', NotifySettingController]
