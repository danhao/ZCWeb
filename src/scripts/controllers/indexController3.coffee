
class IndexController3
	constructor: (@$log, @$window, @$scope, @$interval, @ajaxService, @actionCode, @$resource) ->
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
			dealSum: 32951
			team: 233
			coop: 60
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

		###
		angular.element('#news-owl').owlCarousel({
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
		###
			
		angular.element('#banner').owlCarousel({
			slideSpeed: 300,
			paginationSpeed: 400,
			singleItem: true,
			items: 1,
			responsiveClass: true,
			autoplay: true,
			loop: true
			})

		@initNews()
		

	initNews: ()->
		@newsOption =
			items: 3,
			nav: true,
			dots: false,
			margin: 60,
			responsive: {
				0: { items: 1 },
				600: { items: 3 }
				},
			navText: ['','']

		###
		@news = [
			title: '移动端Cell栏表单设计问题汇总'
			detail: '总表单是用户用来获取服务的重要输入工具，也是收集UGC的重要入口，更是用户与移动端交互的重要途径。'
			pic: '../images/index/media/p1.jpg'
			url: 'http://iof.hexun.com/'
		,
			title: '移动端Cell栏表单设计问题汇总'
			detail: '总表单是用户用来获取服务的重要输入工具，也是收集UGC的重要入口，更是用户与移动端交互的重要途径。'
			pic: '../images/index/media/p1.jpg'
			url: 'http://iof.hexun.com/'
		,
			title: '移动端Cell栏表单设计问题汇总'
			detail: '总表单是用户用来获取服务的重要输入工具，也是收集UGC的重要入口，更是用户与移动端交互的重要途径。'
			pic: '../images/index/media/p1.jpg'
			url: 'http://iof.hexun.com/'
		,
			title: '移动端Cell栏表单设计问题汇总'
			detail: '总表单是用户用来获取服务的重要输入工具，也是收集UGC的重要入口，更是用户与移动端交互的重要途径。'
			pic: '../images/index/media/p1.jpg'
			url: 'http://iof.hexun.com/'
		]
		###
		@newsList = @$resource("data/news.json")
		@news = @newsList.query()

		@$log.log @$scope.news
		
		

angular.module('app').controller 'indexController3', ['$log', '$window', '$scope', '$interval', 'ajaxService', 'actionCode', '$resource', IndexController3]
