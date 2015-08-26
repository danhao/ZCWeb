
class Controller
	constructor: (@$log) ->
		@initMap()

	initMap: ->
		@createMap()			# 创建地图
		@setMapEvent()			# 设置地图事件
		@addMapControl()		# 向地图添加控件
		@addMapOverlay()		# 向地图添加覆盖物

	createMap: ->
		@map = new BMap.Map "map"
		@map.centerAndZoom new BMap.Point(113.951356,22.541432), 19

	setMapEvent: ->
		@map.enableScrollWheelZoom()
		@map.enableKeyboard()
		@map.enableDragging()
		@map.enableDoubleClickZoom()

	addClickHandler: (target, window) ->
		target.addEventListener "click", () ->
			target.openInfoWindow window

	addMapOverlay: ->
		markers = [
			content:"国内首家针对不良资产清收服务P2P以及O2O平台"
			title:"点点债互联网金融服务有限公司"
			imageOffset:
				width:0
				height:3-25		# 3
			position:
				lat:22.541219
				lng:113.951369
		]

		createMarker = (c) =>
			point = new BMap.Point c.position.lng, c.position.lat
			marker = new BMap.Marker point,
				icon: new BMap.Icon "http://api.map.baidu.com/lbsapi/createmap/images/icon.png",
					new BMap.Size(20, 25),
					imageOffset: new BMap.Size c.imageOffset.width, c.imageOffset.height
			label = new BMap.Label c.title,
				offset: new BMap.Size 0,25
			label.setStyle
				color: 'red'
				fontSize: '15px'
			opts =
				width: 200
				title: "<b>#{c.title}</b>"
				enableMessage: false
			infoWindow = new BMap.InfoWindow c.content, opts
			marker.setLabel label
			@addClickHandler marker, infoWindow
			@map.addOverlay marker

		createMarker m for m in markers
		

	addMapControl: ->
		scaleControl = new BMap.ScaleControl {anchor:BMAP_ANCHOR_BOTTOM_LEFT}
		scaleControl.setUnit BMAP_UNIT_IMPERIAL
		@map.addControl scaleControl
		navControl = new BMap.NavigationControl {anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_LARGE}
		@map.addControl navControl
		overviewControl = new BMap.OverviewMapControl {anchor:BMAP_ANCHOR_BOTTOM_RIGHT,isOpen:true}
		@map.addControl overviewControl
		

angular.module('app').controller 'contactController', ['$log', Controller]
