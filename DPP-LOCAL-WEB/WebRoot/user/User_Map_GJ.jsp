<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>管井查询</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>
<!--Zdialog-->
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>


<script type="text/javascript" src="../easyui/jquery.min.js"></script>

<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>


<!--BanRightClick-->
<script language=javascript> document.oncontextmenu=function(){window.event.returnValue=false;};</script>

<style>
	html{height:100%}
	body{height:100%; margin:0px; padding:0px}
	#container{height:100%}
  html,body{width:100%; height:100%; margin:0; padding:0;}/*必须将最外层设置一个高度*/
 
</style>
</head>
<%
	String       Sid          = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String       Project_Id  = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	String       Func_Type_Id = CommUtil.StrToGB2312(request.getParameter("Func_Type_Id"));
	UserInfoBean UserInfo     = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);	
	CurrStatus   currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList    Project_Info = (ArrayList)session.getAttribute("Project_Info_" + Sid);

  int sn = 0;
	//初始化坐标
	double Longitude = 120.201967;
	double Latitude  = 30.276438;
	int MapLev = 18;
	
	if(Project_Info != null && Project_Id != null ){
			Iterator iterator = Project_Info.iterator();
			while(iterator.hasNext()){
					ProjectInfoBean sBean = (ProjectInfoBean)iterator.next();
				  if(sBean.getId().equals(Project_Id)){
				     Longitude	= 	Float.parseFloat(sBean.getLongitude());
				     Latitude  	= 	Float.parseFloat(sBean.getLatitude());
				     MapLev     =   Integer.parseInt(sBean.getMapLev());
				  }
			}
	 }	

%>
<body style="background:#CADFFF">
	<div id="container">	</div>
	<!-- 内页面 -->
		<div style='position:absolute;width:73px;height:20px;right:260px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="添加辅助线" onClick="doAddAssist()" />
		</div>
		<div style='position:absolute;width:60px;height:20px;right:200px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="停止添加" onClick="CloseClick()" />
		</div>
		<div style='position:absolute;width:73px;height:20px;right:120px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="移除辅助线" onClick="doRemAssist()" />
		</div>
		<div style='position:absolute;width:100px;height:20px;right:360px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="管线拉直" onClick="OpenLZGX()" />
			<input id="closeLZGX" type="button" value="关闭" style="display:none;" onClick="closeLZGX()" />
		</div>
		<div id="LZGX" style="display:none;position:absolute;width:160px;height:82px;right:300px;top:23px;background-color:#FFFFFF;overflow:auto;">
			<div>起点管井:<input type="text" id="StartGJ" placeholder="选取井号" style="width:80px;height:18px;left:20px;top:2px;" /></div>
			<div>终点管井:<input type="text" id="EndGJ" placeholder="选取井号" style="width:80px;height:18px;left:20px;top:2px;" /></div>
			<div>
				<input type="radio" name="Bearing" value="1">南北向&nbsp;
        <input type="radio" name="Bearing" value="2">东西向&nbsp;<br>
        <input type="radio" name="Bearing" value="3">斜向&nbsp;
				<input type="button" value="拉直" onClick="doLZGX()"/>&nbsp;
				<input type="button" id="HTLZ" style="display:none;" value="回退" onClick="doHTLZ()"/>
			</div>
		</div>
		
		<div style='position:absolute;width:100px;height:23px;right:14px;top:0px;background-color:#FFFFFF;overflow:auto;'>
		  <form  name="gj_class" >
				<select id="GJ_Select" name="GJ_Select" style="width:100%;height:23px" onChange="doReresh()"> 									  
						<option value=""   <%=Func_Type_Id.equals("J")?"selected":""%>   >管线总地图</option>		
					  <option value="YJ"  <%=Func_Type_Id.equals("YJ")?"selected":""%>  >雨水管线图</option>
					  <option value="WJ"  <%=Func_Type_Id.equals("WJ")?"selected":""%>  >污水管线图</option>
				</select>
		  </form>
	  </div>
	
</body>
<input id="DelFlag" type="hidden" value="0">
<SCRIPT LANGUAGE=javascript>
	
	function doOpen()
	{
		if(document.getElementById('news_info').style.display == '')
		{
			document.getElementById('news_img').src = '../skin/images/map2open.gif';
			document.getElementById('news_img').title = '收起';
			document.getElementById('news_info').style.display = 'none';
		}
		else
		{
			document.getElementById('news_img').src = '../skin/images/map2close.gif';
			document.getElementById('news_img').title = '展开';
			document.getElementById('news_info').style.display = '';
		}
	}

//授权密码
function rightPWD()
{
	var input = prompt("请输入授权密码:");
	//取消
	if(input == null)
	{
		history.go(-1)
		return;
	}
	//确认
	if(input != "111111")
	{
		alert("授权码错误！");
		rightPWD();
	}
	return;
}
rightPWD();

//兼容性
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
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
	point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);      //创建中心点坐标，默认为第一家企业
	map.centerAndZoom(point, <%=MapLev%>);                      //初始化地图，设置中心点坐标和地图级别
	map.addControl(new BMap.NavigationControl());               //添加一个平移缩放控件，位置可偏移、形状可改变
	map.addControl(new BMap.ScaleControl());                    //添加一个比例尺控件，位置可偏移[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
	map.addControl(new BMap.OverviewMapControl());              //添加一个缩略图控件，位置可偏移
	//map.addControl(new BMap.MapTypeControl());                //添加地图类型变换(地图-卫星-三维)，位置可偏移
	map.enableScrollWheelZoom();                                //启用滚轮放大缩小
	
	var gjArray = new Array();
	function gjGet(arrPerson,objPropery,objValue)
	{
   return $.grep(arrPerson, function(cur,i){
   				if(objValue == cur[objPropery])
          	return cur[objPropery];
       });
	}

// 2017.04.01 管线拉直
function bindEvent(func){
	doGJDefence = func;
}
function OpenLZGX()		//打开、重置拉直管线
{
	document.getElementById("LZGX").style.display='';
	document.getElementById("closeLZGX").style.display='';
	var StartGJ = document.getElementById("StartGJ");
	var EndGJ = document.getElementById("EndGJ");
	StartGJ.value = '';
	EndGJ.value = '';
	bindEvent(function(pId){	//重写doGJDefence方法
		if(StartGJ.value.length <= 0)
		{
			StartGJ.value = pId;
		}
		else
		{
			EndGJ.value = pId;
		}
	});
}
function closeLZGX()		//关闭拉直管线
{
	document.getElementById("LZGX").style.display='none';
	document.getElementById("closeLZGX").style.display='none';
	var StartGJ = document.getElementById("StartGJ");
	var EndGJ = document.getElementById("EndGJ");
	StartGJ.value = '';
	EndGJ.value = '';
	bindEvent(function(pId){	//恢复doGJDefence方法
		var Pdiag = new Dialog();
		Pdiag.Top = "50%";
		Pdiag.Width = 180;
		Pdiag.Height = 158;
		Pdiag.Title = "管井属性";
		Pdiag.URL = "User_DevGJ_Info.do?Cmd=4&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>&Id="+pId;
		Pdiag.CancelEvent=function()
		{
			
			Pdiag.close();	//关闭窗口		
			if(1 == document.getElementById('DelFlag').value){
				RealGJStatus();	//页面刷新
				RealGXStatus();	//页面刷新 
				document.getElementById('DelFlag').value = 0;
			}	
		};
		Pdiag.show();
	});
}
var flag = 0;		// flag=0,无回退; flag=1,有回退
function doHTLZ()		//回退拉直
{
	if(window.XMLHttpRequest)
  {
		reqDrg = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
		reqDrg = new ActiveXObject("Microsoft.XMLHTTP");
	}
	reqDrg.onreadystatechange = function()
	{
	  var state = reqDrg.readyState;
	  if(state == 4)
	  {
	    if(reqDrg.status == 200)
	    {
	      var Resp = reqDrg.responseText;
	      if(null != Resp)
	      {
	      	if(Resp.substring(0,4) == '0000')
	      	{
		      	alert('回退成功!');
		      	RealGJStatus();
		      	RealGXStatus();
						doDragend_ajax();
		      	closeHTLZ();
		    		return;
		    	}
	      }
	      else
	      {
	      	alert('回退失败!');
	    		return;
	      }
	    }
	    else
	    {
	    	alert('回退失败!');
	    	return;
	    }
	  }                 
	};
	var url = "Admin_HTLZ.do?Sid=<%=Sid%>&reqReal="+reqRealLZGX+"&Func_Project_Id=<%=Project_Id%>&currtime="+new Date();
	reqDrg.open("POST",url,false);
	reqDrg.send(null);
	return true;
}
function openHTLZ()		//打开回退拉直
{
	document.getElementById("HTLZ").style.display = "";
}
function closeHTLZ()	//关闭回退拉直
{
	document.getElementById("HTLZ").style.display = "none";
}
var reqRealLZGX = null;
function doLZGX()		//管线拉直
{
	var StartGJ = document.getElementById("StartGJ").value;
	var EndGJ = document.getElementById("EndGJ").value;
	var Bearing = "";
	var Bearings = document.getElementsByName("Bearing");
  for(var i=0; i<Bearings.length; i ++){
    if(Bearings[i].checked){
      Bearing = Bearings[i].value;
    }
  }
	if(StartGJ.length <= 0)
	{
		alert("请选择起点管井！");
		return;
	}
	if(EndGJ.length <= 0)
	{
		alert("请选择终点管井！");
		return;
	}
	if(Bearing.length <= 0)
	{
		alert("请选择管线朝向！");
		return;
	}
	if(window.XMLHttpRequest)
  {
		reqDrg = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
		reqDrg = new ActiveXObject("Microsoft.XMLHTTP");
	}
	reqDrg.onreadystatechange = function()
	{
	  var state = reqDrg.readyState;
	  if(state == 4)
	  {
	    if(reqDrg.status == 200)
	    {
	      var Resp = reqDrg.responseText;
	      if(null != Resp)
	      {
		    	if(Resp.substring(4).length > 0)
	      	{
	      		flag = 1;
	      		openHTLZ();
	      		reqRealLZGX = Resp.substring(4);
	      	}
	      	if(Resp.substring(0,4) == '0000')
	      	{
		      	alert('拉直成功!');
		      	RealGJStatus();
		      	RealGXStatus();
						doDragend_ajax();
		    		return;
		    	}
		    	else if(Resp.substring(0,4) == '1111')
		    	{
		    		alert('拉直失败!请确认点位正确');
	    			return;
		    	}
	      }
	      else
	      {
	      	alert('拉直失败!');
	    		return;
	      }
	    }
	    else
	    {
	    	alert('拉直失败!');
	    	return;
	    }
	  }                 
	};
	var url = "Admin_LZGX.do?Sid=<%=Sid%>&StartGJ="+StartGJ+"&EndGJ="+EndGJ+"&Bearing="+Bearing+"&Func_Project_Id=<%=Project_Id%>&currtime="+new Date();
	reqDrg.open("POST",url,false);
	reqDrg.send(null);
	return true;
}
//管线拉直结束

// 2017.03.31 添加辅助线
var markerList = new Array();
var LineList = new Array();
function doAddAssist()		// 开启左键事件
{
	map.addEventListener("click", openClick);
}
function openClick(e)			// 选取地图上的点
{
 	var point = new BMap.Point(e.point.lng, e.point.lat);
 	addMarker(point);
}
function addMarker(point)	// 画出点和辅助线
{
	pX = pY = 5;
	var pIcon  = '../skin/images/map_assist.gif';
	var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
 	var marker = new BMap.Marker(point, {icon: myIcon});
 	markerList.push(marker);
 	map.addOverlay(marker);
 	if(markerList.length > 1)
 	{
 		for(var i = 0; i < LineList.length; i ++)
		{
			map.removeOverlay(LineList[i]);
		}
 		for(var i = 0; i < markerList.length - 1; i ++)
 		{
 			var Line = new BMap.Polyline([markerList[i].point, markerList[i+1].point], {strokeColor:'green', strokeWeight:1, strokeOpacity:1});
  		map.addOverlay(Line);
  		LineList.push(Line);
 		}
 	}
 	marker.enableDragging(); 
 	marker.addEventListener("dragend", function(e)
	{
		doDragend();
	});
}
function doDragend()		// 拖动辅助点，并重绘辅助线
{
	for(var i = 0; i < LineList.length; i ++)
	{
		map.removeOverlay(LineList[i]);
	}
	if(markerList.length > 1)
 	{
 		for(var i = 0; i < markerList.length - 1; i ++)
 		{
 			var Line = new BMap.Polyline([markerList[i].point, markerList[i+1].point], {strokeColor:'green', strokeWeight:1, strokeOpacity:1});
  		map.addOverlay(Line);
  		LineList.push(Line);
 		}
 	}
}
function doDragend_ajax()		// 当地图刷新(修改位置)时，再次画出辅助线
{
	for(var i = 0; i < markerList.length; i ++)
	{
		map.removeOverlay(markerList[i]);
	}
	for(var i = 0; i < LineList.length; i ++)
	{
		map.removeOverlay(LineList[i]);
	}
	for(var i = 0; i < markerList.length; i ++)
	{
		map.addOverlay(markerList[i]);
	}
	if(markerList.length > 1)
 	{
 		for(var i = 0; i < markerList.length - 1; i ++)
 		{
 			var Line = new BMap.Polyline([markerList[i].point, markerList[i+1].point], {strokeColor:'green', strokeWeight:1, strokeOpacity:1});
  		map.addOverlay(Line);
  		LineList.push(Line);
 		}
 	}
}
function doRemAssist()		// 移除辅助线，并关闭左键事件
{
	for(var i = 0; i < markerList.length; i ++)
	{
		map.removeOverlay(markerList[i]);
	}
	for(var i = 0; i < LineList.length; i ++)
	{
		map.removeOverlay(LineList[i]);
	}
	markerList.length = 0;
	LineList.length = 0;
	map.removeEventListener("click", openClick);
}
function CloseClick()			// 关闭左键事件
{
	map.removeEventListener("click", openClick);
}
//添加辅助线结束

//1.添加地图右击添加标注
map.addEventListener("rightclick", function(e)
{
 	doRightClick(e);
});

//2.添加定义标注图标
function addGJMarker(point, pCorp_Id, pCName, pType)
{
	/*
	if(0 != pType){
		var pIcon  = '../skin/images/map_gj_yellow_7.gif';
	}else{
		var pIcon  = (((pCorp_Id.indexOf('YJ')) < 0)?'../skin/images/map_gj_red_6.gif':'../skin/images/map_gj_blue_6.gif');
  }
  */
  //pType中，第一位表示有无设备，第二位表示起终点
	var pX,pY;
  if(pType.substring(0,1) == "1") //有设备
  {
  	if(pType.substring(1,2) == "0")         //起点
  	{
  		pX = pY = 8;
  		var pIcon  = '../skin/images/map_equip_start.gif';
  	}
  	else if(pType.substring(1,2) == "1")     //中间点
		{
			pX = pY = 6;
			var pIcon  = '../skin/images/map_equip_middle.gif';
		}
		else if(pType.substring(1,2) == "2")     //终点
		{
			pX = pY = 8;
			var pIcon  = '../skin/images/map_equip_end.gif';
		}else if(pType.substring(1,2) == "3")    //水位站
		{
			pX = pY = 15;
			var pIcon  = '../skin/images/map_equip_sz.gif';
		}
  }
  else
  {
		if(pCorp_Id.substring(0,2) == "YJ")				//无设备 雨井
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
		else  if(pCorp_Id.substring(0,2) == "HJ")//无设备 合井
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
		}else //无设备 水位站
		{
			pX = pY = 15;
			var pIcon  = '../skin/images/map_sz.gif';
		}
  }
  
	var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
 	var marker = new BMap.Marker(point, {icon: myIcon});
 	var myLabel= new BMap.Label(pCName, {offset:new BMap.Size(0, pY)});
 	
 	myLabel.setStyle
 	({
 		fontSize:"11px",
 		font:"bold 10pt/12pt",
 		border:"0px",
 		color:"black",
 		textAlign:"center",
 		background:"yellow",
 		cursor:"pointer"
 	});
 	/*if(pType.substring(0,1) == "1")
 	{
 		marker.setLabel(myLabel);//文字标记
 	}*/
 	map.addOverlay(marker);
 	
  //点击
 	marker.addEventListener("click", function()
 	{
 		doGJDefence(pCorp_Id);
	});
	
	//拖拽 
	marker.enableDragging(); 
	marker.addEventListener("dragend", function(e)
	{  
		doDragging(pCorp_Id, e.point.lng, e.point.lat, pType);  	
	});
	
}

function addGXMarker(polyline,gxId)
{
	 map.addOverlay(polyline);
	// polyline.addEventListener("click", function()
 	//{
 	//	doGXDefence(gxId);
  //});
} 
	
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
	      	//1.删除
	      	gjArray = [];
					map.clearOverlays();      	
	      	//2.添加
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		  var sublist = list[i].split("|");
	      		  if(sublist[0].indexOf(document.getElementById("GJ_Select").value)< 0){
      		  	 continue;
      		    }
	      		  var point = new BMap.Point(sublist[1], sublist[2]);  
	      		  var gjObj = new Object();

	      		  gjObj.tId = sublist[0];
	      		  gjObj.tPoint = point;
	      		  gjArray.push(gjObj);
    		  
	      			var pName = '水位 : ';
						  addGJMarker(point, sublist[0], pName+sublist[4], sublist[3]);
							//;TSGYJ005-3|120.203581|30.276107|0|0;
	      	}
	      }
	    }
	  }
	};
	var url = "Admin_ToPo_GJ.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
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
	      		if(sublist[1].indexOf(document.getElementById("GJ_Select").value)< 0){
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
      		  var polyline = new BMap.Polyline([gjStart[0].tPoint, gjEnd[0].tPoint], {strokeColor:color, strokeWeight:2.7, strokeOpacity:0.9});
      		  addGXMarker(polyline,gxId);
	      	}
	      }
	    }
	  }
	};
	var url = "Admin_ToPo_GX.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}
RealGJStatus()
RealGXStatus()


//右点击事件
var reqUnMarke = null;
function doRightClick(e)
{
	//获取未标记  XMLHttpRequest 对象用于在后台与服务器交换数据。
	if(window.XMLHttpRequest)
  { // code for all new browsers
		reqUnMarke = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{// code for IE5 and IE6
		reqUnMarke = new ActiveXObject("Microsoft.XMLHTTP");
	}
	reqUnMarke.onreadystatechange = function()
	{
	  var state = reqUnMarke.readyState;
	  if(state == 4)
	  {// 4 = "loaded"
	    if(reqUnMarke.status == 200)
	    {// 200 = OK
	      var Resp = reqUnMarke.responseText;
	      if(null != Resp && Resp.substring(0,4) == '0000')
	      {
	      	//站点
	      	var list = Resp.substring(4).split(';');
					var content = "<select id='Id' name='Id' style='width:220px;height:20px;'>";
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		content += "<option value='"+ list[i] +"'>"+ list[i] +"</option>";
	      	}
					content += "</select>";
					content += "<input type='button' value='标注管井' onClick=\"doAddMarke('0', "+e.point.lng+", "+e.point.lat+")\">";
					var opts = 
					{
					  width : 350, // 信息窗口宽度  
					  height: 60,  // 信息窗口高度  
					  title : ""   // 信息窗口标题
					}
					var infoWindow = new BMap.InfoWindow(content, opts);//创建信息窗口对象  
					map.openInfoWindow(infoWindow, e.point);            //打开信息窗口
	      }  
	      else
	      {
	    		return;
	      }   
	    }
	    else
	    {
	    	return;
	    }
	  }
	};
	var url = "Admin_ToPo_GJ.do?Cmd=23&Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&currtime="+new Date();
	reqUnMarke.open("POST",url,false);
	reqUnMarke.send(null);
	return true;
}

//添加标注
var reqAdd = null;
function doAddMarke(pType, Lng, Lat)
{
	if(document.getElementById('Id').value.length < 1)
	{
		alert('请选择要标注的站点!');
		return;
	}
	var Id = document.getElementById('Id').value;
	if(confirm('确定添加标注?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqAdd.onreadystatechange = function()
		{
		  var state = reqAdd.readyState;
		  if(state == 4)
		  {
		    if(reqAdd.status == 200)
		    {
		      var Resp = reqAdd.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	map.closeInfoWindow();
		      	var point = new BMap.Point(Lng, Lat);
						addGJMarker(point, Id, Id, '7', '7', pType);
		      	alert('添加标注成功!');
		    		return;
		      }
		      else
		      {
		      	alert('添加标注失败!');
		    		return;
		      }
		    }
		    else
		    {
		    	alert('添加标注失败!');
		    	return;
		    }
		  }
		};
		var url = "Admin_Drag_GJ.do?Cmd=17&Sid=<%=Sid%>&Id="+Id+"&Project_Id=<%=Project_Id%>&Longitude="+Lng+"&Latitude="+Lat+"&currtime="+new Date();
		reqAdd.open("POST",url,false);
		reqAdd.send(null);
		return true;
	}
}

//拖拽坐标更新接口
var reqDrg = null;
function doDragging(pId, pLng, pLat, pType)
{
	if(confirm('同步更新当前站点坐标?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqDrg = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDrg = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqDrg.onreadystatechange = function()
		{
		  var state = reqDrg.readyState;
		  if(state == 4)
		  {
		    if(reqDrg.status == 200)
		    {
		      var Resp = reqDrg.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	alert('坐标同步更新成功!');
		      	RealGJStatus();
		      	RealGXStatus();
						doDragend_ajax();
		    		return;
		      }  
		      else
		      {
		      	alert('坐标同步更新失败!');
		    		return;
		      }   
		    }
		    else
		    {
		    	alert('坐标同步更新失败!');
		    	return;
		    }
		  }                 
		};
		var url = "Admin_Drag_GJ.do?Cmd=15&Sid=<%=Sid%>&Id="+pId+"&Project_Id=<%=Project_Id%>&Longitude="+pLng+"&Latitude="+pLat+"&currtime="+new Date();
		reqDrg.open("POST",url,false);
		reqDrg.send(null);
		return true;
	}
}
function writeObj(obj){ 
 var description = ""; 
 for(var i in obj){ 
  var property=obj[i]; 
  description+=i+" = "+property+"\n"; 
 } 
 alert(description); 
} 
//左点击查看管井接口
function doGJDefence(pId)
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 180;
	Pdiag.Height = 158;
	Pdiag.Title = "管井属性";
	Pdiag.URL = "User_DevGJ_Info.do?Cmd=4&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		
		Pdiag.close();	//关闭窗口		
		if(1 == document.getElementById('DelFlag').value){
			RealGJStatus();	//页面刷新
			RealGXStatus();	//页面刷新 
			document.getElementById('DelFlag').value = 0;
		}	
	};
	Pdiag.show();
}
//左点击查看管线接口
function doGXDefence(pId)
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 160;
	Pdiag.Height = 135;
	Pdiag.Title = "管线属性";
	Pdiag.URL = "Admin_DevGX_Info.do?Cmd=3&Sid=<%=Sid%>&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		Pdiag.close();	//关闭窗口
		//RealGJStatus();		//页面刷新
	};
	Pdiag.show();
}

function doReresh()
{
	this.location = "User_Map_GJ.jsp?Project_Id=<%=Project_Id%>&Func_Type_Id="+document.getElementById("GJ_Select").value+"&Sid=<%=Sid%>";
}

</SCRIPT>
</html>