<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>GIS</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>
<script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor.js"></script>
<!--Zdialog-->
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>

<!--EasyUI-->
<link rel="stylesheet" type="text/css" href="../easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../easyui/demo/demo.css">
<script type="text/javascript" src="../easyui/jquery.min.js"></script>
<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>

<!--BanRightClick-->
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>

<style>
	html{height:100%}
	body{height:100%; margin:0px; padding:0px}
	#container{height:100%}
  html,body{width:100%; height:100%; margin:0; padding:0;}/*必须将最外层设置一个高度*/
  .mesWindow{border:#C7C5C6 1px solid;background:#CADFFF;}
  .mesWindowTop{background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{ position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}

  #news_info
  {

  }
  body{
 -moz-user-select:none;
 hutia:expression(this.onselectstart=function(){return(false)});
}
</style>

<iframe width=0 height=0 frameborder=0 name=hrong style="display:none"></iframe>
</head>
<%
	String       Sid              = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String 			 Project_Id 			= CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	ArrayList    Project_Info     = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	CorpInfoBean Corp_Info        = (CorpInfoBean)session.getAttribute("Corp_Info_" + Sid);
	
	String Demo = "";
	if(Corp_Info != null)
	{
		Demo = Corp_Info.getDemo();
  	if(Demo == null){Demo = "";}
 	}
 	
	String IdList = "";
	

	double Longitude = 0.0;
	double Latitude  = 0.0;
	int    MapLev = 0;
	//初始化所在项目的位置
	if(null != Project_Info){
		Iterator deviter = Project_Info.iterator();
		while(deviter.hasNext()){
			ProjectInfoBean projectBean = (ProjectInfoBean)deviter.next();
			if(Project_Id.equals(projectBean.getId())){
					//初始化坐标
					Longitude = Double.parseDouble(projectBean.getLongitude());
					Latitude  = Double.parseDouble(projectBean.getLatitude());
					//初始化倍数
					MapLev  = Integer.parseInt(projectBean.getMapLev());
					break;
				}
		}
	}
	int sn = 0;
%>
<body style="background:#CADFFF">
	<!-- 地图 -->
	<div id="container"></div>

	<!-- 左边栏页面 天气和公告 -->
	<div id='news_info_left' style='position:absolute;left:15px;top:0px;background-color:#CADFFF;'>
			<div id="tq" class="easyui-tabs" style="width:270px;height:490px"  >
				<div title="事件公告" style="padding:10px" align=center >
					 <iframe width="225" scrolling="no" height="80" frameborder="0" allowtransparency="true" src="http://i.tianqi.com/index.php?c=code&id=8&icon=5"></iframe>
					 <%=Demo%>
				</div>
				<div title="气象预告" style="padding:10px;overflow:hidden">
				   <iframe name="weather_inc" src="http://i.tianqi.com/index.php?c=code&id=82&py=hangzhou" width="250" height="440" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
				</div>
				
			</div>
	</div>
	<!-- 右边栏固定地图 -->
		<div id='map_1' style='display:;position:absolute;width:86px;height:23px;right:3px;top:0px;background-color:#FFFFFF;overflow:auto;'>
			<select id="Func_Map_Id_All" style="width:100%;height:23px" onChange="doReresh()"> 									  
				<option value=""   >管线总地图</option>		
			  <option value="YJ" >雨水管线图</option>
			  <option value="WJ" >污水管线图</option>
			</select>
		</div>
		<div id='map_2' style='display:none;position:absolute;width:86px;height:23px;right:3px;top:0px;background-color:#FFFFFF;overflow:auto;'>
			<select id="Func_Map_Id_One" style="width:100%;height:23px" onChange="doReresh()">
			</select>
		</div>
		<div id='map_3' style='display:none;position:absolute;width:150px;height:40px;right:3px;top:25px;background-color:#FFFFFF;overflow:auto;'>
			<form>
				<input type="button" id="addCenter"     style="display:;"        onClick="MarkCenter()"     value="标注中心"> 
				<input type="button" id="remCenter"     style="display:none;"    onClick="remCenterMark()"  value="取消标注"> &nbsp;
				<input type="button" id="OpenGJ"        style="display:;"        onClick="OpenGJId()"       value="显示编号">
				<input type="button" id="CloseGJ"       style="display:none;"    onClick="remGJId()"      value="隐藏编号">
				<br>
				<input type="button" onClick="downloadGIS()"value="导出静态图" />
			</form>
		</div>
	<!-- 左右隐藏条 -->
	<div id='menu_info_L' style='position:absolute;width:16px;height:100%;left:0px;top:0px;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity:0.5;background-color:#bbbdbb;'>
		<img id='news_img_left' src='../skin/images/map2open.gif' style='width:16px;height:16px;cursor:hand;' title='收起' onclick='doOpenLeft()'>
	</div>
	
	<!-- 弹出框口 -->
	<div id="win"></div>
	
	<div id="winload" style="display:none;position:absolute;left:-1px;top:-1px;width:100%;height:100%;background-color:#FFFFFF;opacity:0.4;"> 
		<div style="position:absolute;top:30%;left:45%;border:1px solid #000000;opacity:1;">图片导出中,请等待...</div>
	</div>
</body>

<!--表格数据JS处理-->
<script language=javascript>

	function doOpenLeft()
	{
		if(document.getElementById('news_info_left').style.display == '')
		{
			document.getElementById('news_img_left').src = '../skin/images/map2close.gif';
			document.getElementById('news_img_left').title = '收起';
			document.getElementById('news_info_left').style.display = 'none';
		}
		else
		{
			document.getElementById('news_img_left').src = '../skin/images/map2open.gif';
			document.getElementById('news_img_left').title = '展开';
			document.getElementById('news_info_left').style.display = '';
		}
	}
</script>


<!--BaiduMap JS处理-->
<SCRIPT LANGUAGE=javascript>
//兼容性
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())//若是iphone,ipad
{
	window.addEventListener('onorientationchange' in window ? 'orientationchange' : 'resize', setHeight, false);
	setHeight();
}
function setHeight()
{
	document.getElementById('container').style.height = document.body.offsetHeight + 'px';
}

//载入地图
var map = new BMap.Map("container");                        //创建地图实例
//map.setMapType(BMAP_HYBRID_MAP);                          //默认类型为卫星、路网一体
var point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);  //创建中心点坐标，默认为第一家企业
map.centerAndZoom(point, <%=MapLev%>);                      //初始化地图，设置中心点坐标和地图级别
//map.addControl(new BMap.NavigationControl());             //添加一个平移缩放控件，位置可偏移、形状可改变
map.addControl(new BMap.ScaleControl());                    //添加一个比例尺控件，位置可偏移[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
map.addControl(new BMap.OverviewMapControl());              //添加一个缩略图控件，位置可偏移
//map.addControl(new BMap.MapTypeControl());                //添加地图类型变换(地图-卫星-三维)，位置可偏移
map.enableScrollWheelZoom();                                //启用滚轮放大缩小

//管线段集合
var gjArray = new Array();
var gxArray = new Array();
function gjGet(arrPerson,objPropery,objValue)
{
 return $.grep(arrPerson, function(cur,i){
 				if(objValue == cur[objPropery])
        	return cur[objPropery];
     });
}

function formatDate(now) {
	var year=now.getFullYear(); 
	var month=now.getMonth()+1; 
	var date=now.getDate(); 
	var hour=now.getHours(); 
	var minute=now.getMinutes(); 
	var second=now.getSeconds(); 
	return year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second; 
}
var newTime = formatDate(new Date());

//2.添加定义标注图标
function addGJMarker(point, pCorp_Id, pCName, pType, pCTime)
{	
	/*if(0 != pType){
		var pIcon  = '../skin/images/map_gj_yellow_7.gif';
	}else{
		var pIcon  = (((pCorp_Id.indexOf("YJ")) < 0)?'../skin/images/map_gj_red_6.gif':'../skin/images/map_gj_blue_6.gif');
  }*/
 
//pType中，第一位表示有无设备，第二位表示起终点
	var pX,pY;
  if(pType.substring(0,1) == "1") //有设备
  {
  	if(pType.substring(1,2) == "0")        //起点
  	{
  		pX = pY = 8;
  		var pIcon  = '../skin/images/map_equip_start.gif';
  	}
  	else if(pType.substring(1,2) == "1")   //中间点
		{
			pX = pY = 6;
			var pIcon  = '../skin/images/map_equip_middle.gif';
		}
		else if(pType.substring(1,2) == "2")   //终点
		{
			pX = pY = 8;
			var pIcon  = '../skin/images/map_equip_end.gif';
		}
		else  if(pType.substring(1,2) == "3")  //水位站
		{
			pX = pY = 15;
			var pIcon  = '../skin/images/map_equip_sz.gif';
		}
  }
  else
  {
		if(pCorp_Id.substring(0,2) == "YJ")		  //无设备 雨井
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_yj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_yj_middle.gif';
			}
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_yj_end.gif';
			}
		}
		else if(pCorp_Id.substring(0,2) == "WJ") //无设备 污井
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_wj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_wj_middle.gif';
			}
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_wj_end.gif';
			}
		}
		else if(pCorp_Id.substring(0,2) == "HJ") //无设备 合流井
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_hj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_hj_middle.gif';
			}
			else if(pType.substring(1,2) == "2")
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_hj_end.gif';
			}
		}
		else    //无设备 水位站
		{
			pX = pY = 15;
			var pIcon  = '../skin/images/map_sz.gif';
		}
  }
  
	var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
 	var marker = new BMap.Marker(point, {icon: myIcon});
 	var myLabel= new BMap.Label(pCName, {offset:new BMap.Size(0, pY)});
 	
 	var color = "";
 	if(pType.substring(0,1) == "1" && pCTime.length > 0)
 	{
 		var time = ((new Date(newTime).getTime() - new Date(pCTime).getTime()))/(60*60*1000);
 		if(time < 2)
 		{
 			color = "yellow";
 		}
 		else
 		{
 			color = "red";
 		}
 	}
 	myLabel.setStyle
 	({
 		fontSize:"11px",
 		font:"bold 10pt/12pt",
 		border:"0px",
 		color:"black",
 		textAlign:"center",
 		background:color,
 		cursor:"pointer"
 	});
	if(pType.substring(0,1) == "1")
 	{
 		marker.setLabel(myLabel);//文字标记
 	//marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳跃动画
 	}	
 	map.addOverlay(marker);
 	
 	
  //点击
 	marker.addEventListener("click", function()
 	{
 		doGJDefence(pCorp_Id, pType);
	});
}

// 下载静态图 2017年4月\
var projection = null;
var Func_Map_Id_One = "";
var Func_Map_Id_All = "";
var centerMark = null;
var center = "";
var Zoom = "<%=MapLev%>"*1;
map.addEventListener("zoomend", function(e){ 
	Zoom = this.getZoom();
	var that = this;
	remFrame();
	remBlock();
	countFrame(center);  
	countBlock(center, 1024, 0); 
});
function MarkCenter()	//标注中心点
{
	map.addEventListener("click", function(e)		// 开启左键事件
	{
		if(center.length > 0)
		{
			return;
		}
	 	projection = this.getMapType().getProjection();
		var point = new BMap.Point(e.point.lng, e.point.lat);
	 	var marker = new BMap.Marker(point);
	 	map.addOverlay(marker);
	 	centerMark = marker;
	 	marker.enableDragging();
	 	marker.addEventListener("dragend", function(e)
		{
			center = e.point.lng + "," + e.point.lat;
			remFrame();
			remBlock();
			countFrame(center);
			countBlock(center, 1024, 0);
		});
	 	center = e.point.lng + "," + e.point.lat;
	 	countFrame(center);
	 	countBlock(center, 1024, 0);
	 	document.getElementById("addCenter").style.display = "none";
	 	document.getElementById("remCenter").style.display = "";
	});
}

function remCenterMark() //取消标注
{
	center = "";
	remFrame();
	remBlock();
	map.removeOverlay(centerMark);
	document.getElementById("addCenter").style.display = "";
 	document.getElementById("remCenter").style.display = "none";
}

// 计算对应边框的位置
var frameArray = new Array();
var reqRealDF = null;
function countFrame(center)
{
	if(window.XMLHttpRequest)
  {
    reqRealDF = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRealDF = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealDF.onreadystatechange = function(){
		var state = reqRealDF.readyState;
		if(state == 4)
	  {
	    if(reqRealDF.status == 200)
	    {
	      var Resp = reqRealDF.responseText;
	      if(Resp != null && Resp.length > 0 && Resp.substring(0,4) == '0000')
	      {
	      	var json = eval("("+Resp.substring(4)+")");
	      	frameArray.length = 0;
	      	var p01 = new BMap.Point(json.result[0].x, json.result[0].y);
					var p02 = new BMap.Point(json.result[1].x, json.result[1].y);
					var p03 = new BMap.Point(json.result[2].x, json.result[2].y);
					var p04 = new BMap.Point(json.result[3].x, json.result[3].y);
					var polyline01 = new BMap.Polyline([p01, p02], {strokeColor:"red", strokeWeight:2.7, strokeOpacity:0.9});
					var polyline02 = new BMap.Polyline([p01, p03], {strokeColor:"red", strokeWeight:2.7, strokeOpacity:0.9});
					var polyline03 = new BMap.Polyline([p02, p04], {strokeColor:"red", strokeWeight:2.7, strokeOpacity:0.9});
					var polyline04 = new BMap.Polyline([p03, p04], {strokeColor:"red", strokeWeight:2.7, strokeOpacity:0.9});
	      	map.addOverlay(polyline01);
	      	map.addOverlay(polyline02);
	      	map.addOverlay(polyline03);
	      	map.addOverlay(polyline04);
					frameArray.push(polyline01);
					frameArray.push(polyline02);
					frameArray.push(polyline03);
					frameArray.push(polyline04);
	    	}
	  	}
		}
	}
	var point = new BMap.Point(center.split(",")[0], center.split(",")[1]);
	var pointToPixel = projection.lngLatToPoint(point);
	var lng = pointToPixel.x;
	var lat = pointToPixel.y;
	
	var p01 = (lng - Math.floor(512 * Math.pow(2, 18 - Zoom))) + "," + (lat + Math.floor(512 * Math.pow(2, 18 - Zoom)));
	var p02 = (lng + Math.floor(512 * Math.pow(2, 18 - Zoom))) + "," + (lat + Math.floor(512 * Math.pow(2, 18 - Zoom)));
	var p03 = (lng - Math.floor(512 * Math.pow(2, 18 - Zoom))) + "," + (lat - Math.floor(512 * Math.pow(2, 18 - Zoom)));
	var p04 = (lng + Math.floor(512 * Math.pow(2, 18 - Zoom))) + "," + (lat - Math.floor(512 * Math.pow(2, 18 - Zoom)));
	var coords = p01+";"+p02+";"+p03+";"+p04;;
	var	url = "User_drawFrame.do?Sid=<%=Sid%>&coords="+coords;
	reqRealDF.open('POST',url,false);
	reqRealDF.send(null);
}

// 计算对应块的位置
var blockArray = new Array();
var reqRealDF = null;
function countBlock(pCenter, size, pType)
{
	if(window.XMLHttpRequest)
  {
    reqRealDF = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRealDF = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealDF.onreadystatechange = function(){
		var state = reqRealDF.readyState;
		if(state == 4)
	  {
	    if(reqRealDF.status == 200)
	    {
	      var Resp = reqRealDF.responseText;
	      if(Resp != null && Resp.length > 0 && Resp.substring(0,4) == '0000')
	      {
	      	var json = eval("("+Resp.substring(4)+")");
	      	//画块
					var p01 = new BMap.Point(json.result[0].x, json.result[0].y);
					var p02 = new BMap.Point(json.result[1].x, json.result[1].y);
					var p03 = new BMap.Point(json.result[2].x, json.result[2].y);
					var p04 = new BMap.Point(json.result[3].x, json.result[3].y);
					polyline_1 = new BMap.Polyline([p01, p02], {strokeColor:"red", strokeWeight:1, strokeOpacity:0.7});
					polyline_2 = new BMap.Polyline([p03, p04], {strokeColor:"red", strokeWeight:1, strokeOpacity:0.7});
					map.addOverlay(polyline_1);
					map.addOverlay(polyline_2);
					blockArray.push(polyline_1);
					blockArray.push(polyline_2);
	    	}
	  	}
		}
	}
	var point = new BMap.Point(pCenter.split(",")[0], pCenter.split(",")[1]);
	var pointToPixel = projection.lngLatToPoint(point);
	var lng = pointToPixel.x;
	var lat = pointToPixel.y;
	
	var point01 = lng + "," + (lat + Math.floor((size/2) * Math.pow(2, 18 - Zoom)));
	var point02 = lng + "," + (lat - Math.floor((size/2) * Math.pow(2, 18 - Zoom)));
	var point03 = (lng - Math.floor((size/2) * Math.pow(2, 18 - Zoom))) + "," + lat;
	var point04 = (lng + Math.floor((size/2) * Math.pow(2, 18 - Zoom))) + "," + lat;
	
	var label01 = (lng - Math.floor((size/4) * Math.pow(2, 18 - Zoom))) + "," + (lat + Math.floor((size/4) * Math.pow(2, 18 - Zoom)))
	var label02 = (lng + Math.floor((size/4) * Math.pow(2, 18 - Zoom))) + "," + (lat + Math.floor((size/4) * Math.pow(2, 18 - Zoom)))
	var label03 = (lng - Math.floor((size/4) * Math.pow(2, 18 - Zoom))) + "," + (lat - Math.floor((size/4) * Math.pow(2, 18 - Zoom)))
	var label04 = (lng + Math.floor((size/4) * Math.pow(2, 18 - Zoom))) + "," + (lat - Math.floor((size/4) * Math.pow(2, 18 - Zoom)))
	var coords = point01+";"+point02+";"+point03+";"+point04+";"+label01+";"+label02+";"+label03+";"+label04;
	var	url = "User_drawFrame.do?Sid=<%=Sid%>&coords="+coords;
	reqRealDF.open('POST',url,false);
	reqRealDF.send(null);
}

function remBlock() //移除块和编号
{
	for(var i = 0; i < blockArray.length; i ++)
	{
		map.removeOverlay(blockArray[i]);
	}
}
function remFrame()	//移除边框
{
	for(var i = 0; i < frameArray.length; i ++)
	{
		map.removeOverlay(frameArray[i]);
	}
}

var GJIdFalg = 0;
var gjIdLabel = new Array();
function OpenGJId()		// 打开管井Id
{
	for(var i = 0; i < gjArray.length; i ++)
	{
		var Id = gjArray[i].tId.substring(5);
		var myLabel= new BMap.Label(Id, {offset:new BMap.Size(0,0),position:gjArray[i].tPoint});
		myLabel.setStyle({
	    fontSize:"10px",
	    border:"1px solid #000000",
	    color:"black",
	    background:"#ffffff",
	    cursor:"pointer"
		});
		gjIdLabel.push(myLabel);
		map.addOverlay(myLabel);
	}
	document.getElementById("OpenGJ").style.display = "none";
	document.getElementById("CloseGJ").style.display = "";
	GJIdFalg = 1;
}
function remGJId()		// 移除管井Id
{
	for(var i = 0; i < gjIdLabel.length; i ++)
	{
		map.removeOverlay(gjIdLabel[i]);
	}
	document.getElementById("OpenGJ").style.display = "";
	document.getElementById("CloseGJ").style.display = "none";
	GJIdFalg = 0;
}

function writeObj(obj){ 
 var description = ""; 
 for(var i in obj){ 
 var property=obj[i]; 
 description+=i+" = "+property+"\n"; 
 } 
 alert(description); 
}

var reqRealDG = null;
function downloadGIS()   //下载
{
	Func_Map_Id_All = document.getElementById("Func_Map_Id_All").value;
	Func_Map_Id_One = document.getElementById("Func_Map_Id_One").value;
	if(Func_Map_Id_All.length <= 0)
	{
		Func_Map_Id_One = "";
	}
	var Func_Type_Map_Id = Func_Map_Id_All + Func_Map_Id_One;
	if(center.length <= 0)
	{
		alert("请选择地图中心点！");
		return;
	}
	document.getElementById("winload").style.display=""; 
	if(window.XMLHttpRequest)
  {
    reqRealDG = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRealDG = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealDG.onreadystatechange = function(){
		var state = reqRealDG.readyState;
		if(state == 4)
	  {
	    if(reqRealDG.status == 200)
	    {
	      var Resp = reqRealDG.responseText;
	      if(Resp != null && Resp.length > 0)
	      {
					document.getElementById("winload").style.display="none";
	      	if(Resp.substring(0,4) == '0000')
	      	{
		      	var a = document.createElement('a');
						//a.href = "http://121.41.52.236/dpp/files/downloadGIS/L.png";
						a.href = "http://121.41.52.236/dpp/" + Resp.split("DPP-LOCAL-WEB")[1];
						a.download = Func_Type_Map_Id+".png";
						a.click();
						window.URL.revokeObjectURL(Url);
						
						remCenterMark();
						remGJId();
					}
					else if(Resp.substring(0,4) == '9999')
					{
						alert("图片导出失败！");
					}
	    	}
	   	}
	  }
  }
  var url = "User_downloadGIS.do";
  var data ="Sid=<%=Sid%>&Project_Id=<%=Project_Id%>"+
  					"&Id="+Func_Type_Map_Id+
  					"&Center="+center+
  					"&Zoom="+Zoom+
  					"&GJIdFalg="+GJIdFalg+
  					"&currtime="+new Date();
	reqRealDG.open('POST',url,true);
	reqRealDG.setRequestHeader("Content-Type","application/x-www-form-urlencoded");  
	reqRealDG.send(data);
}
//下载静态图结束


function addGXMarker(polyline,gxId)
{
	 map.addOverlay(polyline);
	 polyline.addEventListener("click", function()
 	{
 		doGXDefence(gxId);
	});
} 

var reqRealGJId = "";
//管井状态监控
var reqRealGJ = null;
function RealGJStatus()
{
	Func_Map_Id_All = document.getElementById("Func_Map_Id_All").value;
	Func_Map_Id_One = document.getElementById("Func_Map_Id_One").value;
	var hj = "HJ";
	if(Func_Map_Id_All.length <= 0)
	{
		hj = "";
	}
	hj = hj + Func_Map_Id_One;
	var gjType = Func_Map_Id_All + Func_Map_Id_One;
	gjArray.length = 0;
	if(window.XMLHttpRequest)
  {
    reqRealGJ = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRealGJ = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealGJ.onreadystatechange = function(){
	  var state = reqRealGJ.readyState;
	  if(state == 4)
	  {
	    if(reqRealGJ.status == 200)
	    {
	      var Resp = reqRealGJ.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	//1.删除
					map.clearOverlays();      	
	      	//2.添加
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
      		  var sublist = list[i].split("|");
      		  if(reqRealGJId.indexOf(sublist[0].substring(0,5)) < 0 && sublist[0].indexOf(Func_Map_Id_All) >= 0)
      		  {
      		  	reqRealGJId += sublist[0].substring(0,5) + ",";
      		  }
      		  if(sublist[0].indexOf(gjType) < 0 && sublist[0].indexOf(hj) < 0){
    		  	  continue;
    		    }
      		  var point = new BMap.Point(sublist[1], sublist[2]);  
      		  var gjObj = new Object();

      		  gjObj.tId = sublist[0];
      		  gjObj.tPoint = point;
      		  gjArray.push(gjObj);
					  addGJMarker(point, sublist[0], parseFloat(sublist[4]).toFixed(2)+'m', sublist[3], sublist[5]);
					  //addGJId(point, sublist[0]);
						//TSGYJ005-3|120.203581|30.276107|0|0;
	      	}
	      	doGJIdDefence(reqRealGJId);
	      	reqRealGJId = "";
	      }
	    }
	  }
	};
	var url = "User_ToPo_GJ.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGJ.open('POST',url,false);
	reqRealGJ.send(null);
}

//管线状态监控
var reqRealGX = null;
function RealGXStatus()
{
	Func_Map_Id_All = document.getElementById("Func_Map_Id_All").value;
	Func_Map_Id_One = document.getElementById("Func_Map_Id_One").value;
	var hj = "HJ";
	if(Func_Map_Id_All.length <= 0)
	{
		hj = "";
	}
	hj = hj + Func_Map_Id_One;
	var gjType = Func_Map_Id_All + Func_Map_Id_One;
	gxArray.length = 0;
	if(window.XMLHttpRequest)
  {
    reqRealGX = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRealGX = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealGX.onreadystatechange = function(){
	  var state = reqRealGX.readyState;
	  if(state == 4)
	  {
	    if(reqRealGX.status == 200)
	    {
	      var Resp = reqRealGX.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {

	      	//2.添加
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		var sublist = list[i].split("|");
	      		
	      		if(sublist[1].indexOf(gjType) < 0 && sublist[1].indexOf(hj) < 0){
      		  	 continue;
      		  }
    		  	var gxId      = sublist[0];
    		  	var gjStartId = sublist[1];
    		  	var gjEndId   = sublist[2];
    		  	var gjStart   = gjGet(gjArray, "tId", gjStartId);      		  	
      		  var gjEnd     = gjGet(gjArray, "tId", gjEndId);      		  
      		  if(null == gjStart[0] || null == gjEnd[0]){continue;}
      		  var color = "";
      		  if(gxId.indexOf("WG") >= 0)
      		  {	      		  
						  color = "red";
      		  }
      		  else if(gxId.indexOf("YG") >= 0)
      		  {
							color = "blue";
      		  }
      		  else if(gxId.indexOf("HG") >= 0)
      		  {
							color = "green";
      		  }
      		  var gxObj = new Object();
      		  gxObj.gjStart = gjStart;
      		  gxObj.gjEnd = gjEnd;
      		  gxArray.push(gxObj);
      		  var polyline = new BMap.Polyline([gjStart[0].tPoint, gjEnd[0].tPoint], {strokeColor:color, strokeWeight:2.7, strokeOpacity:0.9});
      		  addGXMarker(polyline,gxId);
	      	}
	      }
	    }
	  }
	};
	var url = "User_ToPo_GX.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}
RealGJStatus()
RealGXStatus()

//左点击查看接口
var reqInfo = null;
function doGJDefence(pId, pType)
{
	var dUrl = "User_DevGJ_Info.do?Sid=<%=Sid%>&Cmd=3&Func_Project_Id=<%=Project_Id%>&Id="+pId;
	$('#win').window({
		title: '管井编码:'+pId,
		top:($(window).height() - 380),
		left: ($(window).width() - 605),
    width:600,
    height:375,
    href:dUrl,
    draggable:false,
    collapsible:false,
    minimizable:false,
    maximizable:true,
    modal:true,
    onResize:function(width, height){
    },
    onBeforeClose:function(){
			$('#win').window('close', true);//这里调用close 方法，true 表示面板被关闭的时候忽略onBeforeClose 回调函数。
    }
  });
}

//左点击查看管线接口
function doGXDefence(pId)
{
	var dUrl = "User_DevGX_Info.do?Cmd=3&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>&Id="+pId;
	$('#win').window({  
		title: '管线属性:', 
    width:220,
    height:163,
    href:dUrl,
    draggable:false,
    collapsible:false,
    minimizable:false,
    maximizable:false,
    modal:true,
    onBeforeClose:function(){
			$('#win').window('close', true); //这里调用close 方法，true 表示面板被关闭的时候忽略onBeforeClose 回调函数。
    }
  });
}

//子系统号监控
function doGJIdDefence(pGJIds)
{
	var Options = document.getElementById("Func_Map_Id_One");
	Options.options.length=0;
	var GJIdArray = pGJIds.split(",");
	var oOption = new Option("所有子系统","");
	oOption.selected = true;
	Options.options.add(oOption);
	for(var i = 0; i < GJIdArray.length - 1; i ++)
	{
		oOption = new Option(GJIdArray[i],GJIdArray[i].substring(2));
		if(Func_Map_Id_One == GJIdArray[i].substring(2))
		{
			oOption.selected = true;
		}
		Options.options.add(oOption);
	}
}

function doReresh()
{
	RealGJStatus();
	RealGXStatus();
	remCenterMark();
	remGJId();
	
	if(Func_Map_Id_All.length > 0)
	{
		document.getElementById("map_2").style.display = "";
		document.getElementById("map_1").style.right = "90px";
	}
	else
	{
		document.getElementById("map_2").style.display = "none";
		document.getElementById("map_1").style.right = "3px";
		document.getElementById("map_3").style.display = "none";
	}
	if(Func_Map_Id_One.length > 0)
	{
		document.getElementById("map_3").style.display = "";
	}
	else
	{
		document.getElementById("map_3").style.display = "none";
	}
}

/**
//GPS坐标120.1901508262859, 30.273735911737216] 120.1901508262859, 30.273735911737216]   {"Lng":120.19474183989372,"Lat":30.271342407430293}
var xx = 120.19474183989372;
var yy = 30.271342407430293;
var gpsPoint = new BMap.Point(xx,yy);

//添加谷歌marker和label
addGJMarker(gpsPoint, 'YJ001001', '1', '00')

//坐标转换完之后的回调函数
translateCallback = function (point){
    addGJMarker(point, 'WJ001001', '2', '00')
//    alert("转化为百度坐标为："+point.lng + "," + point.lat);
}
BMap.Convertor.translate(gpsPoint, 2 ,translateCallback);     //真实经纬度转成百度坐标
**/
</SCRIPT>
</html>