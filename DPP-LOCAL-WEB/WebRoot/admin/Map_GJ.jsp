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
  .mesWindow{border:#C7C5C6 1px solid;background:#CADFFF;}
  .mesWindowTop{background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{ position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}

  #news_info
  {

  }
</style>
</head>
<%
	String       Sid          = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String       pProject_Id  = CommUtil.StrToGB2312(request.getParameter("pProject_Id"));
	String       Func_Type_Id = CommUtil.StrToGB2312(request.getParameter("Func_Type_Id"));
	UserInfoBean UserInfo     = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);	
	CurrStatus   currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList    Project_Info = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	
  int sn = 0;
	//初始化坐标
	double Longitude = 120.201967;
	double Latitude  = 30.276438;
	int MapLev = 18;
	String Pro_Id = "";
	
	if(Project_Info != null && pProject_Id != null ){
			Iterator iterator = Project_Info.iterator();
			while(iterator.hasNext()){
					ProjectInfoBean sBean = (ProjectInfoBean)iterator.next();
				  if(sBean.getId().equals(pProject_Id)){
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
		<div id='news_info' style='position:absolute;width:200px;height:23px;right:14px;top:0px;background-color:#FFFFFF;overflow:auto;'>
		  <form  name="gj_class" >
		  	<select id="Project_Select" name="Project_Select" style="width:49%;height:23px" onChange="doReresh()"> 									  
							 <%	
 	                if(Project_Info != null){
		  								Iterator iterator = Project_Info.iterator();
											while(iterator.hasNext()){
											ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
										  Pro_Id   = statBean.getId();
											String Pro_Name = statBean.getCName();										
							 %>
								    <option value="<%=Pro_Id%>" <%=pProject_Id.equals(Pro_Id)?"selected":""%>> <%=Pro_Name%></option>
							 <%
		    						 }
									}
							 %>
				</select>
				<select id="GJ_Select" name="GJ_Select" style="width:48%;height:23px" onChange="doReresh()"> 									  
						<option value="J"   <%=Func_Type_Id.equals("J")?"selected":""%>   >管线总地图</option>		
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
  	if(pType.substring(1,2) == "0")
  	{
  		pX = pY = 8;
  		var pIcon  = '../skin/images/map_equip_start.gif';
  	}
  	else if(pType.substring(1,2) == "1")
		{
			pX = pY = 6;
			var pIcon  = '../skin/images/map_equip_middle.gif';
		}
		else
		{
			pX = pY = 8;
			var pIcon  = '../skin/images/map_equip_end.gif';
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
		else  //无设备 污井
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
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_hj_end.gif';
			}
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
 		doGJDefence(pCorp_Id, pType);
	});
	
	//拖拽 
	/*marker.enableDragging(); 
	marker.addEventListener("dragend", function(e)
	{  
		doDragging(pCorp_Id, e.point.lng, e.point.lat, pType);  	
	});*/
	
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
	var url = "Admin_ToPo_GJ.do?Cmd=21&Id="+document.getElementById("Project_Select").value+"&Sid=<%=Sid%>&currtime="+new Date();
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
	var url = "Admin_ToPo_GX.do?Cmd=21&Id="+document.getElementById("Project_Select").value+"&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}
RealGJStatus()
RealGXStatus()


//右点击事件
/*var reqUnMarke = null;
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
	var url = "Admin_ToPo_GJ.do?Cmd=23&Sid=<%=Sid%>&Project_Id=<%=pProject_Id%>&currtime="+new Date();
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
		var url = "Admin_Drag_GJ.do?Cmd=17&Sid=<%=Sid%>&Id="+Id+"&Project_Id="+document.getElementById("Project_Select").value+"&Longitude="+Lng+"&Latitude="+Lat+"&currtime="+new Date();
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
		var url = "Admin_Drag_GJ.do?Cmd=15&Sid=<%=Sid%>&Id="+pId+"&Project_Id="+document.getElementById("Project_Select").value+"&Longitude="+pLng+"&Latitude="+pLat+"&currtime="+new Date();
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
} */
//左点击查看管井接口
function doGJDefence(pId, pType)
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 550;
	Pdiag.Height = 375;
	Pdiag.Title = "管井编码: "+pId;
	Pdiag.URL = "Admin_DevGJ_Info.do?Sid=<%=Sid%>&Cmd=6&Func_Project_Id="+document.getElementById("Project_Select").value + "&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		Pdiag.close();	//关闭窗口
    //RealStatus();		//页面刷新
	};
	Pdiag.show();
}

//左点击查看管井接口(原)
/*function doGJDefence(pId, pType)
{
	
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 180;
	Pdiag.Height = 158;
	Pdiag.Title = "管井属性";
	Pdiag.URL = "Admin_DevGJ_Info.do?Cmd=6&Sid=<%=Sid%>&Func_Project_Id=<%=pProject_Id%>&Id="+pId;
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
}*/
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
	this.location = "Map_GJ.jsp?pProject_Id="+document.getElementById("Project_Select").value+"&Func_Type_Id="+document.getElementById("GJ_Select").value+"&Sid=<%=Sid%>";
}

</SCRIPT>
</html>