class Filter
	constructor: (@$log) ->
		
		getFileExt = (url) ->
			u1 = url.split("?")[0]
			u2s = u1.split(".")
			u2s[u2s.length-1].toLowerCase()

		imgExts =
			["jpg", "jpeg", "ico", "png", "bmp"]

		return (value) ->
			# @$log.log value
			ext = getFileExt(value)
			if ext in imgExts
				value
			else
				"images/filetype/"+ext+".png"
			

angular.module('app').filter 'imgurl', ['$log', Filter]
