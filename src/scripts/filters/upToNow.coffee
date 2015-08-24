
class Filter

	constructor: (@$log, @utilService) ->
		# time:
		###
		return (time) =>
			diff = Math.abs(Date.now() - (time * 1000))
			diff_day = diff / (24 * 60 * 60 * 1000)
			r = diff_day
			ret = ""
			y = Math.floor(r/365)
			if y > 0
				ret += y + '年'
				r = r - y * 365
			m = Math.floor r/30
			if m > 0
				ret += m + '月'
				r = r - m * 30
			ret += (Math.floor(r) + '天') if r > 0
			ret
			###
		
		return @utilService.upToNow

			

angular.module('app').filter 'upToNow', ['$log', 'utilService', Filter]
