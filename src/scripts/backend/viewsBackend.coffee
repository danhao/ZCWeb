class Run
	constructor: (@$log, @$httpBackend) ->
		@$httpBackend.whenGET(/^.*\.(html|htm)$/).passThrough()
		@$httpBackend.whenGET(/^.*\.(json)$/).passThrough()

angular.module('app').run ['$log', '$httpBackend', Run]
