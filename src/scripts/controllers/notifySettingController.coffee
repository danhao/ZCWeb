class NotifySettingController

	constructor: (@$log, @ajaxService, @actionCode) ->
		# @$log.log 'init controller'
		
		
	saveSettings: (form, setting) ->
		@save setting
		
	enableNotify: (setting) ->
		@save setting

	save: (setting) ->
		data = angular.copy(setting)
		data.on = if setting.on then 1 else 0
		data.location = setting.city.cn.join("/")
		# @$log.log data
		@ajaxService.post @actionCode.ACTION_SET_ALERT, data
			# .success (result) =>
				# @$log.log result
				# do nothing
			.error (error) =>
				@$log.log error


angular.module("app").controller "notifySettingController", ['$log', 'ajaxService', 'actionCode', NotifySettingController]
