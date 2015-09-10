
class IndexController3
	constructor: (@$log, @$window, @$scope, @$interval, @ajaxService, @actionCode) ->
		# wow
		# new WOW().init()

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

		# stat data
		@stat_t =
			dealSum: 30953
			team: 216
			coop: 48
		@stat =
			dealSum: 0
			team: 0
			coop: 0

		t = @$interval ()=>
			if @stat.dealSum < @stat_t.dealSum
				@stat.dealSum += 281
			else
				@stat.dealSum = @stat_t.dealSum
				
			if @stat.team < @stat_t.team
				@stat.team += 1
				
			if @stat.coop < @stat_t.coop
				@stat.coop += 1
				
			if @stat.dealSum >= @stat_t.dealSum and @stat.team >= @stat_t.team and @stat.coop >= @stat_t.coop
				@$interval.cancel t
		, 10

		@$scope.$on '$destroy', () =>
			if t
				@$interval.cancel t

		
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
			responsiveClass: true,
			autoplay: true,
			loop: true
			})
		
		

angular.module('app').controller 'indexController3', ['$log', '$window', '$scope', '$interval', 'ajaxService', 'actionCode', IndexController3]
