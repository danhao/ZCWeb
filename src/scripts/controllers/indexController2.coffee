
class IndexController2
	constructor: (@$log, @$window, @ajaxService, @actionCode) ->
		# wow
		new WOW().init()

		# vegas
		###
		angular.element("#wrapper").vegas
			delay: 7000
			slides: [
				{ src:'/images/backgrounds/bg1.jpg' },
				{ src:'/images/backgrounds/bg2.jpg' },
				{ src:'/images/backgrounds/bg3.jpg' }
			]
			# walk: () ->
			# 	angular.element(".vegas-slide").height height
		###

		@rating=4

		# latest debts
		@ajaxService.post @actionCode.ACTION_LIST_VIEW_DEBTS, {type: 1, state: 1}
			.success (result) =>
				@debtList = result.debt
			.error (error) ->
				@$log.log error
		
		# sample users
		
		

angular.module('app').controller 'indexController2', ['$log', '$window', 'ajaxService', 'actionCode', IndexController2]
