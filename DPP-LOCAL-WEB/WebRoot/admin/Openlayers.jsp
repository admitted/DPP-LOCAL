<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>����һ���򵥵ĵ��ӵ�ͼ</title>
	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<!-- ����OpenLayers ��� -->
	<script type="text/javascript" src="../skin/js/OpenLayers.js">
	</script>
	<style>
		html, body { width: 100%; height: 100%; margin: 0; padding: 0; }
	</style>
	<!-- �ؼ������������� -->
	<script type="text/javascript">
		function init() {
		// ʹ��ָ�����ĵ�Ԫ�ش�����ͼ
		var map = new OpenLayers.Map("rcp1_map");
		// ����һ�� OpenStreeMap raster layer
		// �����ͼ����ӵ�map��
		var osm = new OpenLayers.Layer.OSM();
		map.addLayer(osm);
		// �趨��ͼ���ŵ�ͼ�̶�Ϊ���
		map.zoomToMaxExtent();
		}
	</script>
	</head>
	 
	<body onload="init()">
		<div id="rcp1_map" style="width: 100%;height: 100%;">
		</div>
	</body>
 
</html>
