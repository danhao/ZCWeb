class Directive
	constructor: ($log, $interval, $parse, utilService) ->
		
		getTemplate = (diff) ->
			t = ''
			t += (diff.Y + ' 年 ') if diff.Y > 0
			t += (diff.M + ' 月 ') if diff.M > 0
			t += (diff.d + ' 日 ') if diff.d > 0
			t += (diff.H + ' 时 ') if diff.H > 0
			t += (diff.m + ' 分 ') if diff.m > 0
			t += (if diff.s >= 10 then diff.s else '0' + diff.s) + ' 秒 '
			t

		link = (scope, element, attrs) ->
			
			updateTime = () ->
				expireDay = $parse(attrs.countdown)(scope)
				diff = expireDay - Date.now()
				diffObj = utilService.formatTimeRange diff
				template = getTemplate diffObj
				element.html template

			element.on '$destroy', () ->
				$interval.cancel timeoutId

			timeoutId = $interval () ->
				updateTime()
			, 1000

			attrs.$observe 'countdown', (val) ->
				updateTime()


		return {
			link: link,
		}


angular.module('app').directive 'countdown', ['$log', '$interval', '$parse', 'utilService', Directive]
