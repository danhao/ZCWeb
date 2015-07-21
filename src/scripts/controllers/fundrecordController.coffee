class FundrecordController
	constructor: (@$log,@$scope,@$rootScope,@$state, @$stateParams,@ajaxService, @actionCode,@utilService,@$timeout,@growlService) ->
		date = new Date()
		monthday = date.getFullYear()+"/"+(date.getMonth()+1)+"/01"
		timefrom = monthday
		timeto =  date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate()
		@q =
			type:'0'
			timeFrom:timefrom
			timeTo:timeto

		@$scope.$watch () => @q
		,
		(newValue, oldValue) =>
			if newValue isnt oldValue
				getList()
		, true


		getList = () =>
			timefrom =utilService.gettimestamp @q.timeFrom,0
			timeto = utilService.gettimestamp @q.timeTo,1
			param = _.mapObject @q, parseInt
			param.timeFrom =timefrom
			param.timeTo =timeto

			@ajaxService.post @actionCode.ACTION_LIST_MONEY_HISTORY, param
			.success (rets) ->
				$scope.fundrecordList = rets.history
			.error (error) ->
				growlService.growl(error.desc, 'danger')

		getList()

angular.module("app")
	.controller 'fundrecordController', ['$log','$scope','$rootScope','$state','$stateParams','ajaxService', 'actionCode','utilService','$timeout','growlService', FundrecordController]

