<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>                  
	<meta http-equiv=Content-Type content="text/html;charset=utf-8">
	<meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
	<meta content=always name=referrer>
	<title>华家池校区高清地图</title>
	<link href="../skin/ol/ol.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="../skin/ol/ol.js" charset="utf-8"></script>
	<script type="text/javascript" src="../easyui/jquery.min.js"></script>

	<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
	<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
	<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
	<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>
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
</head>

<%
	String       Sid              = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String 			 Project_Id 			= CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	String       Func_Type_Map_Id = CommUtil.StrToGB2312(request.getParameter("Func_Type_Map_Id"));
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

<body>
	<!-- 地图 -->
  <div id="map" style="width: 100%"></div>
  <!-- 左边栏页面 天气和公告 
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
	<!-- 右边栏固定地图 --
	<div id='news_info_map' style='position:absolute;width:86px;height:23px;right:3px;top:0px;background-color:#FFFFFF;overflow:auto;'>
		<select id="Func_Type_Map_Id" style="width:100%;height:23px" onChange="doReresh()"> 									  
			<option value=""   <%=Func_Type_Map_Id.equals("J")?"selected":""%>   >管线总地图</option>		
		  <option value="YJ"  <%=Func_Type_Map_Id.equals("YJ")?"selected":""%>  >雨水管线图</option>
		  <option value="WJ"  <%=Func_Type_Map_Id.equals("WJ")?"selected":""%>  >污水管线图</option>
		</select>
	</div>
	
	<!-- 左右隐藏条 --
	<div id='menu_info_L' style='position:absolute;width:16px;height:100%;left:0px;top:0px;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity:0.5;background-color:#bbbdbb;'>
		<img id='news_img_left' src='../skin/images/map2open.gif' style='width:16px;height:16px;cursor:hand;' title='收起' onclick='doOpenLeft()'>
	</div>
	
	<!-- 弹出框口-->
	<div id="win"></div>
	
</body>

<SCRIPT LANGUAGE=javascript>
	// 地图设置中心，设置到华家池
	//var center = ol.proj.transform([120.19451, 30.26957], 'EPSG:3857', 'EPSG:4326');
	
	// 添加一个使用离线瓦片地图的层
	var offlineMapLayer = new ol.layer.Tile({
	  source: new ol.source.XYZ({
      // 设置本地离线瓦片所在路径
      url: '../mapTile/ZJU_HJC/GoogleMap/L{z}/R{y}/C{x}.png'
	  })
	});

	// google地图层
	var googleMapLayer = new ol.layer.Tile({
	  source: new ol.source.XYZ({
	    url:'http://www.google.cn/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i345013117!3m8!2szh-CN!3scn!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0'
	  })
	});

	// 管井层
	var gjLayer = new ol.layer.Vector({
	  source: new ol.source.Vector()
	});
	// 管线层
	var gxLayer = new ol.layer.Vector({
    source: new ol.source.Vector()
	});
	
	var map = new ol.Map({
		layers: [ offlineMapLayer, gxLayer, gjLayer
	  ],
	  view: new ol.View({ 
	    // 设置杭州华家池为地图中心
	    center: [120.19555, 30.26903],
	    // 指定投影使用EPSG:4326
	    projection: 'EPSG:4326',
	    zoom: 17,
	    minZoom: 16,
	    maxZoom: 22
	  }),
		controls: ol.control.defaults().extend([
	    new ol.control.MousePosition({
	    	coordinateFormat: ol.coordinate.createStringXY(4),
	    	projection: 'EPSG:4326'
			})
	  ]),

	  target: 'map'
	});

	// 添加比列尺
	map.addControl(new ol.control.ScaleLine());
	// 显示鼠标经纬度
	map.on('pointermove',function(e){
	   var coord = e.coordinate;  
	   var degrees = ol.proj.transform(coord, 'EPSG:3857','EPSG:4326');  
	   var hdms = ol.coordinate.toStringXY(degrees, 8);  
	   $('#longlat').text(hdms);
	});

	/**
	// 为地图注册鼠标点击事件的监听
	map.on('singleclick', function(event){
	    map.forEachFeatureAtPixel(event.pixel, function(feature){
	        // 为移动到的feature发送自定义的mousemove消息
	        feature.dispatchEvent({type: 'mousemove', event: event});
	    });
	}); */

	function writeObj(obj){
	  var description = "";
	  for(var i in obj){
	    var property=obj[i];
	    description+=i+" = "+property+"\n";
	  }
	  alert(description);
	}
	
	// 管线段集合
	var gjArray = new Array();
	function gjGet(arrPerson,objPropery,objValue)
	{
		return $.grep(arrPerson, function(cur,i){
			if(objValue == cur[objPropery])
			return cur[objPropery];
		});
	}

	// 添加定义标注图标
	function addGJMarker(pX, pY, pCorp_Id, pCName, pType)
	{
	  var pIcon = '';
	  if(pType.substring(0,1) == "1") //有设备
	  {
	  	if(pType.substring(1,2) == "0")        //起点
	  	{
	  		pIcon  = '../skin/images/map_equip_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")   //中间点
			{
				pIcon  = '../skin/images/map_equip_middle.gif';
			}
			else if(pType.substring(1,2) == "2")   //终点
			{
				pIcon  = '../skin/images/map_equip_end.gif';
			}
			else  if(pType.substring(1,2) == "3")//水位站
			{
				pIcon  = '../skin/images/map_equip_sz.gif';
			}
	  }
	  else
	  {
			if(pCorp_Id.substring(0,2) == "YJ")		  //无设备 雨井
			{
		  	if(pType.substring(1,2) == "0")
		  	{
		  		pIcon  = '../skin/images/map_yj_start.gif';
		  	}
		  	else if(pType.substring(1,2) == "1")
				{
					pIcon  = '../skin/images/map_yj_middle.gif';
				}
				else
				{
					pIcon  = '../skin/images/map_yj_end.gif';
				}
			}
			else if(pCorp_Id.substring(0,2) == "WJ") //无设备 污井
			{
		  	if(pType.substring(1,2) == "0")
		  	{
		  		pIcon  = '../skin/images/map_wj_start.gif';
		  	}
		  	else if(pType.substring(1,2) == "1")
				{
					pIcon  = '../skin/images/map_wj_middle.gif';
				}
				else
				{
					pIcon  = '../skin/images/map_wj_end.gif';
				}
			}
			else if(pCorp_Id.substring(0,2) == "HJ") //无设备 合流井
			{
		  	if(pType.substring(1,2) == "0")
		  	{
		  		pIcon  = '../skin/images/map_hj_start.gif';
		  	}
		  	else if(pType.substring(1,2) == "1")
				{
					pIcon  = '../skin/images/map_hj_middle.gif';
				}
				else if(pType.substring(1,2) == "2")
				{
					pIcon  = '../skin/images/map_hj_end.gif';
				}
			}
			else    //无设备 水位站
			{
				pIcon  = '../skin/images/map_sz.gif';
			}
	  }
	  
	  var feature = new ol.Feature({
	  	geometry: new ol.geom.Point([pX, pY])
	  });
	  
	  feature.setId(pCorp_Id);
	  feature.setStyle(new ol.style.Style({
	    image: new ol.style.Icon({
	      src: pIcon
	    })
	  }));
	  gjLayer.getSource().addFeature(feature);
	}
	//第一个点
	var gj1 = new ol.Feature({
		geometry: new ol.geom.Point([120.1941, 30.2713])
	});
	//  {"Lng":120.19474183989372,"Lat":30.271342407430293}
	gj1.setStyle(new ol.style.Style({
	image: new ol.style.Icon({
	  	src: '../skin/images/mapimg/14/map_yj_start.gif'
		})
	}));
	gjLayer.getSource().addFeature(gj1);
	//第二个点
	var gj2 = new ol.Feature({
		geometry: new ol.geom.Point([120.1944, 30.2713])
	});
	//  {"Lng":120.19474183989372,"Lat":30.271342407430293}
	gj2.setStyle(new ol.style.Style({
	image: new ol.style.Icon({
	  	src: '../skin/images/mapimg/14/map_yj_middle.gif'
		})
	}));
	gjLayer.getSource().addFeature(gj2);
	//第三个点
	var gj3 = new ol.Feature({
		geometry: new ol.geom.Point([120.1947, 30.2713])
	});
	//  {"Lng":120.19474183989372,"Lat":30.271342407430293}
	gj3.setStyle(new ol.style.Style({
	image: new ol.style.Icon({
	  	src: '../skin/images/mapimg/14/map_yj_end.gif'
		})
	}));
	gjLayer.getSource().addFeature(gj3);
	//第四个点
	var gj4 = new ol.Feature({
		geometry: new ol.geom.Point([120.1950, 30.2713])
	});
	//  {"Lng":120.19474183989372,"Lat":30.271342407430293}
	gj4.setStyle(new ol.style.Style({
	image: new ol.style.Icon({
	  	src: '../skin/images/mapimg/14/map_yj_middle.gif'
		})
	}));
	gjLayer.getSource().addFeature(gj4);
	//第五个点
	var gj5 = new ol.Feature({
		geometry: new ol.geom.Point([120.1953, 30.2713])
	});
	//  {"Lng":120.19474183989372,"Lat":30.271342407430293}
	gj5.setStyle(new ol.style.Style({
	image: new ol.style.Icon({
	  	src: '../skin/images/mapimg/14/map_yj_middle.gif'
		})
	}));
	gjLayer.getSource().addFeature(gj5);
	//第一根线
	var gx1 = new ol.Feature({
		geometry:new ol.geom.LineString([[120.1941, 30.2713], [120.1944, 30.2713]])
  });
  gx1.setStyle(new ol.style.Style({
  	stroke: new ol.style.Stroke({  
      width: 3,
     	color: 'blue'
    })
  }));
  gxLayer.getSource().addFeature(gx1);
  //第二根线
	var gx2 = new ol.Feature({
		geometry:new ol.geom.LineString([[120.1944, 30.2713], [120.1947, 30.2713]])
  });
  gx2.setStyle(new ol.style.Style({
  	stroke: new ol.style.Stroke({  
      width: 3,
     	color: 'blue'
    })
  }));
  gxLayer.getSource().addFeature(gx2);
  //第三根线
	var gx3 = new ol.Feature({
		geometry:new ol.geom.LineString([[120.1947, 30.2713], [120.1950, 30.2713]])
  });
  gx3.setStyle(new ol.style.Style({
  	stroke: new ol.style.Stroke({  
      width: 3,
     	color: 'blue'
    })
  }));
  gxLayer.getSource().addFeature(gx3);
  //第四根线
	var gx4 = new ol.Feature({
		geometry:new ol.geom.LineString([[120.1950, 30.2713], [120.1953, 30.2713]])
  });
  gx4.setStyle(new ol.style.Style({
  	stroke: new ol.style.Stroke({  
      width: 3,
     	color: 'blue'
    })
  }));
  gxLayer.getSource().addFeature(gx4);
	
	//标注管线
	function addGXMarker(StartGJ,EndGJ,gxId)
	{
		var pColor = '';
		if(gxId.substring(0,2) == 'WG')
		{
			pColor = 'red';
		}else if(gxId.substring(0,2) == 'YG')
		{
			pColor = 'blue';
		}
		var feature = new ol.Feature({
			geometry:new ol.geom.LineString([[StartGJ.tPX, StartGJ.tPY], [EndGJ.tPX, EndGJ.tPY]])
	  });
	  feature.setId(gxId);
	  feature.setStyle(new ol.style.Style({
	  	stroke: new ol.style.Stroke({  
        width: 3,
       	color: pColor
      })
	  }));
	  gxLayer.getSource().addFeature(feature);
	}
	
	var selectSingleClick = new ol.interaction.Select({
    // API文档里面有说明，可以设置style参数，用来设置选中后的样式，但是这个地方我们注释掉不用，因为就算不注释，也没作用，为什么？
    // style: new ol.style.Style({
    //     image: new ol.style.Circle({
    //         radius: 10,
    //         fill: new ol.style.Fill({
    //             color: 'blue'
    //         })
    //     })
    // })
	});
	map.addInteraction(selectSingleClick);
	// 监听选中事件，然后在事件处理函数中改变被选中的`feature`的样式
	selectSingleClick.on('select', function(event){
		if(event.selected[0].getId().substring(1,2) == 'J')
		{
			doGJDefence(event.selected[0].getId());
		}else if(event.selected[0].getId().substring(1,2) == 'G')
		{
			doGXDefence(event.selected[0].getId());
		}else
		{
			doGJDefence(event.selected[0].getId());
		}
		//alert(event.selected[0])
	  //writeObj(event.selected[0]);
	})
	/**
	//管井状态监控
	var reqRealGJ = null;
	function RealGJStatus()
	{
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
		      	//2.添加
		      	var list = Resp.substring(4).split(";");
		      	for(var i=0; i<list.length && list[i].length>0; i++)
		      	{
	      		  var sublist = list[i].split("|");
	      		  if(sublist[0].indexOf(document.getElementById("Func_Type_Map_Id").value)< 0){
	    		  	  continue;
	    		    }
	    		    var gjObj = new Object();
	      		  gjObj.tId = sublist[0];
	      		  gjObj.tPX = sublist[1];
	      		  gjObj.tPY = sublist[2];
	      		  gjArray.push(gjObj);
	      		  
	    		    addGJMarker(sublist[1], sublist[2], sublist[0], parseFloat(sublist[4]).toFixed(2)+'m', sublist[3]);
		      	}
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
		      		
		      		if(sublist[1].indexOf(document.getElementById("Func_Type_Map_Id").value)< 0){
	      		  	 continue;
	      		  }
	    		  	var gxId = sublist[0];
	    		  	var gjStartId = sublist[1];
	    		  	var gjEndId = sublist[2];
	    		  	var gjStart = gjGet(gjArray, "tId", gjStartId);      		  	
	      		  var gjEnd   = gjGet(gjArray, "tId", gjEndId);      		  
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
	      		  //alert(gjStart[0].tPX + ":" + gjStart[0].tPY);
	      		   
	      		  //var polyline = new BMap.Polyline([gjStart[0].tPoint, gjEnd[0].tPoint], {strokeColor:color, strokeWeight:2.7, strokeOpacity:0.9});
	      			addGXMarker(gjStart[0],gjEnd[0],gxId);
		      	}
		      }
		    }
		  }
		};
		var url = "User_ToPo_GX.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
		reqRealGX.open('POST',url,false);
		reqRealGX.send(null);
	}

	RealGJStatus();
	RealGXStatus();
//addGXMarker();
**/
	//加入管井图标层
	var vector = new ol.layer.Vector({source: new ol.source.Vector({
		features: [gjLayer, gxLayer]
	})});
	map.addLayer(vector);

	//左点击查看管井接口
	var reqInfo = null;
	function doGJDefence(pId)
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

</SCRIPT>

</html>