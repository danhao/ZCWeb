class DebtService
	url = 'http://127.0.0.1:30001/'

	constructor: (@$log, @$http) ->

	create: (debt) ->
		data =
			code: 100
			pid: '605679232240062465'
			sid: 'c5432f47-e709-4376-ae54-b87915755c3e'
			req: debt
		@$http.post("#{url}", data)
		.error (results, status) ->
			{results, status}

	list :(type,status) ->
		ListDebtsReq=
			type:type
			state:status
		data=
			code: 101
			pid: '605679232240062465'
			sid: 'c5432f47-e709-4376-ae54-b87915755c3e'
			req: ListDebtsReq

		@$http.get("#{url}",data)
		.success (results) ->
			results
		.error (results,status) ->
			{results,status}



angular.module('app').service 'debtService', ['$log', '$http', DebtService]
