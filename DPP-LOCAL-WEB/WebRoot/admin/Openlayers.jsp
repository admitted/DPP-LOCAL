<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>创建一个简单的电子地图</title>
	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<!-- 加载OpenLayers 类库 -->
	<script type="text/javascript" src="../skin/js/OpenLayers.js">
	</script>
	<style>
		html, body { width: 100%; height: 100%; margin: 0; padding: 0; }
	</style>
	<!-- 关键代码在这里了 -->
	<script type="text/javascript">
		function init() {
		// 使用指定的文档元素创建地图
		var map = new OpenLayers.Map("rcp1_map");
		// 创建一个 OpenStreeMap raster layer
		// 把这个图层添加到map中
		var osm = new OpenLayers.Layer.OSM();
		map.addLayer(osm);
		// 设定视图缩放地图程度为最大
		map.zoomToMaxExtent();
		}
	</script>
	</head>
	 
	<body onload="init()">
		<div id="rcp1_map" style="width: 100%;height: 100%;">
		</div>
	</body>
 
</html>
