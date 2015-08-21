class Service
	
	types = [
		{ name: 'M0', value: 0, text: 'M0', from: 0, to: 14 },
		{ name: 'M1', value: 1, text: 'M1', from: 15, to: 29 },
		{ name: 'M2', value: 2, text: 'M2', from: 30, to: 59 },
		{ name: 'M3', value: 3, text: 'M3', from: 60, to: 89 },
		{ name: 'Q1', value: 4, text: '一手', from: 90, to: 179 },
		{ name: 'Q2', value: 5, text: '二手', from: 180, to: 269 },
		{ name: 'Q3', value: 6, text: '三手', from: 270, to: 359 },
		{ name: 'Q4', value: 7, text: '四手', from: 360, to: -1 }
	]
	
	constructor: (@$log) ->

	getTypeByDay: (day) ->
		ret = _.find types, (t) ->
			if t.from isnt -1 and t.to isnt -1
				t.from <= day <= t.to
			else if t.from is -1
				day < t.to
			else if t.to is -1
				day > t.from
			else
				null
		ret

	getTypeByValue: (val) ->
		_.find types, (t) ->
			t.value is val

angular.module('app').service 'handTypeService', ['$log', Service]
