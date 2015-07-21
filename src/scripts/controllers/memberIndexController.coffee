class Controller
	constructor: (@$log,@$scope, @actionCode, @ajaxService, @userSession,@$state, @$stateParams) ->
		initindex = () =>
			@pid = @userSession.pid()
			@ajaxService.post @actionCode.GET_USER, {id: @pid}
				.success (result) =>
					$scope.email=result.email
					$scope.isverifyemail =  (result.status&1)==1
					$scope.isverifymobile=  (result.status&2)==2
					if result.type==0
						$scope.isverifyinfo = (result.status&4)==4
					else
						$scope.isverifyinfo = (result.status&8)==8
					@user = result
				.error (error) =>
					$log.log error
		initindex()

		situationlist = () =>
			@ajaxService.post @actionCode.ACTION_LIST_SITUAION, null
			.success (rets) ->
				$log.log rets
				$scope.situationlist = rets.situation
			.error (error) ->
				growlService.growl(error.desc, 'danger')

		situationlist()

angular.module('app')
				.controller 'memberIndexController', ['$log','$scope', 'actionCode', 'ajaxService', 'userSession','$state','$stateParams', Controller]