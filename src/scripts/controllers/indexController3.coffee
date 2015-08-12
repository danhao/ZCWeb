
class IndexController3
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
		angular.element('#media-owl').owlCarousel({
			items: 3,
			nav: true,
			dots: false,
			margin: 60,
			responsive: {
				0: { items: 1 },
				600: { items: 3 }
				},
			navText: ['','']
			})

		angular.element('#banner').owlCarousel({
			slideSpeed: 300,
			paginationSpeed: 400,
			singleItem: true,
			items: 1,
			responsiveClass: true
			})
		
		

angular.module('app').controller 'indexController3', ['$log', '$window', 'ajaxService', 'actionCode', IndexController3]
