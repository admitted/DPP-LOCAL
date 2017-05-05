<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>GIS</title>
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
	String       Sid              = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String 			 Project_Id 			= CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	String       Func_Type_Map_Id = CommUtil.StrToGB2312(request.getParameter("Func_Type_Map_Id"));
	CurrStatus   currStatus       = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList    Project_Info     = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	CorpInfoBean Corp_Info        = (CorpInfoBean)session.getAttribute("Corp_Info_" + Sid);
	ArrayList    WaterAcc         = (ArrayList)session.getAttribute("WaterAcc_" + Sid);
	String       Time             = CommUtil.StrToGB2312(request.getParameter("Time"));
	
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
<body style="background:#F5F3F0">
	<!-- 地图 -->
	<div id="container" ></div>
	<form name="Analog_rainfall" action="Analog_rainfall.do" method="post" enctype="multipart/form-data">
		<div style='position:absolute;width:206px;height:23px;right:270px;top:0px;background-color:#FFFFFF;overflow:auto;'>
			<input name='file' type='file' style='width:170px;height:20px;' title='数据导入'>
			<input type="button" onClick='doAnalog_Import()' value="提交"/>
		</div>
		<div id="start" style='display:;position:absolute;width:60px;height:20px;right:190px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" onClick='doDeleteData()' value="删除数据"/>
		</div>
		<div style='position:absolute;width:65px;height:23px;right:120px;top:0px;background-color:#FFFFFF;overflow:auto;'>
			<select id="Func_Type_Map_Id" name="Func_Type_Map_Id" style="width:100%;height:23px" onChange="RealStatus();"> 									  

			</select>
		</div>
		<div style='position:absolute;width:60px;height:23px;right:60px;top:0px;background-color:#FFFFFF;overflow:auto;'>
			<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
			<input type="hidden" name="Sid" value="<%=Sid%>">
			<select id="Time" name="Time" style="width:100%;height:23px" onChange="RealStatus();">
				<%
				for(int i = 1; i < 49; i ++){
				%> 									  
				<option value='<%=i%>' <%=Time.equals(String.valueOf(i))?"selected":""%> > <%=i%></option>
				<%
				}
				%>		
			</select>
		</div>
		<div id="start" style='display:;position:absolute;width:31px;height:20px;right:20px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="播放" onClick="doStart()" />
		</div>
		<div id="stop" style='display:none;position:absolute;width:31px;height:20px;right:20px;top:2px;background-color:#FFFFFF;overflow:auto;'>
			<input type="button" value="停止" onClick="doStop()"/>
		</div>
		</form>
	<!-- 弹出框口 -->
	<div id="win"></div>
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
	function gjGet(arrPerson,objPropery,objValue)
	{
   return $.grep(arrPerson, function(cur,i){
   				if(objValue == cur[objPropery])
          	return cur[objPropery];
       });
	}


//2.添加定义标注图标
function addGJMarker(point, pCorp_Id, pCName,pType, pPW)
{	
	var pX,pY;

  if(pPW != 'none')
  {
  	if(pPW*1 < 10)
  	{
  		if(pType == "0")
  		{
  			pX = pY = 10;
  			var pIcon  = '../skin/images/Water_1_start.gif';
  		}else if(pType == "2")
  		{
  			pX = pY = 10;
  			var pIcon  = '../skin/images/Water_1_end.gif';
  		}else
  		{
  			pX = pY = 10;
  			var pIcon  = '../skin/images/Water_1.gif';
  		}
  	}
  	else if(pPW*1 >= 10 && pPW*1 <= 50 )
  	{
			if(pType == "0")
			{
				pX = pY = 15;
				var pIcon  = '../skin/images/Water_2_start.gif';
			}else if(pType == "2")
			{
				pX = pY = 15;
				var pIcon  = '../skin/images/Water_2_end.gif';
			}else
			{
	  		pX = pY = 15;
	  		var pIcon  = '../skin/images/Water_2.gif';
	  	}
  	}
  	else
  	{
  		if(pType == "0")
			{
				pX = pY = 20;
				var pIcon  = '../skin/images/Water_3_start.gif';
			}else if(pType == "2")
			{
				pX = pY = 20;
				var pIcon  = '../skin/images/Water_3_end.gif';
			}else
			{
	  		pX = pY = 20;
	  		var pIcon  = '../skin/images/Water_3.gif';
	  	}
  	}
  }
  else
	{
		if(pCorp_Id.substring(0,2) == "YJ")				//无设备 雨井
		{
	  	if(pType == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_yj_start.gif';
	  	}
	  	else if(pType == "1")
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
	  	if(pType == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_wj_start.gif';
	  	}
	  	else if(pType == "1")
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
		else  //无设备 合井
		{
	  	if(pType == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_hj_start.gif';
	  	}
	  	else if(pType == "1")
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
 	//marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳跃动画
 	}	*/
 	map.addOverlay(marker);
 	
 	
  //点击
 	marker.addEventListener("click", function()
 	{
 		doGJDefence(pCorp_Id, pPW);
	});
}

function addGXMarker(polyline,gxId,gjId)
{
	 map.addOverlay(polyline);
	 polyline.addEventListener("click", function()
 	{
 		doGXDefence(gxId,gjId);
	});
} 

//管井状态监控
/***var reqRealGJ = null;
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
					map.clearOverlays();      	
	      	//2.添加
	      	var gjList = Resp.substring(4).split(";");
	      	for(var i=0; i<gjList.length; i++)
	      	{
      		  var sublist = gjList[i].split("|");

						if('00000' != document.getElementById("Func_Type_Map_Id").value)
						{
							if(sublist[0].substring(0,5) != document.getElementById("Func_Type_Map_Id").value)
								continue;
						}
  		  	  var point = new BMap.Point(sublist[1], sublist[2]);
      		  var gjObj = new Object();
      		  gjObj.tId = sublist[0];
      		  gjObj.tPoint = point;
      		  gjArray.push(gjObj);
      		  var water = 'none';
      		  if(null != sublist[4])
      		  {
      		  	water = sublist[4];
      		  }
						addGJMarker(point, sublist[0], sublist[0], sublist[3], water);
						//YJ001001|120.206177|30.277215|0;YJ001002|120.205903|30.277203|1;
						//@yj002,1|8|12|18|16|0|0|0|0|0|;2|9|13|19|24|12|0|0|0|0|;@
						
	      	}
	      }
	    }
	  }
	};
	var Func_Type_Id = '';
	var Func_Sub_Type_Id = '';
	if('00000' == document.getElementById("Func_Type_Map_Id").value)
	{
		for(var i=0; i<document.getElementById("Func_Type_Map_Id").options.length; i++)
    {
    	if('00000' != document.getElementById("Func_Type_Map_Id")[i].value)
        Func_Type_Id += document.getElementById("Func_Type_Map_Id").options[i].value + ",";
        
    }
    Func_Sub_Type_Id = 'YJ';
	}
	else
	{
		Func_Type_Id = document.getElementById("Func_Type_Map_Id").value;
		Func_Sub_Type_Id = Func_Type_Id;
	}
	var TimePeriod = document.getElementById("Time").value;
	var url = "Analog_ToPo_GJ.do?Cmd=22&Id=<%=Project_Id%>&Sid=<%=Sid%>&Func_Sub_Type_Id=" + Func_Sub_Type_Id + "&Func_Type_Id=" + Func_Type_Id + "&TimePeriod=" + TimePeriod + "&currtime="+new Date();

	reqRealGJ.open('POST',url,false);
	reqRealGJ.send(null);
}***/


var reqRealGJ = null;
function RealGJStatus()
{
	var message="";
	var Func_Type_Id = '';
	var Func_Sub_Type_Id = '';
	if('00000' == document.getElementById("Func_Type_Map_Id").value)
	{
		for(var i=0; i<document.getElementById("Func_Type_Map_Id").options.length; i++)
    {
    	if('00000' != document.getElementById("Func_Type_Map_Id")[i].value)
        Func_Type_Id += document.getElementById("Func_Type_Map_Id").options[i].value + ",";
        
    }
    Func_Sub_Type_Id = 'WJ';
	}
	else
	{
		Func_Type_Id = document.getElementById("Func_Type_Map_Id").value;
		Func_Sub_Type_Id = Func_Type_Id;
	}
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
	      var yjWaterList = "";
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
					//组合数据
					var Time = (document.getElementById("Time").value)*1-1;
					var SysId = "";
					var flag = 0;		//默认没有积水量计算=0
					var waterCnt = 0;	//遍历积水量结果值
					var WaterAcc = "";//当前时段当前子系统的积水量
					var yjList = Resp.substring(4).split(";");
					//开始组合
					for(var i=0; i<yjList.length; i++)
					{
						if(yjList[i].substring(0, 5)==SysId)
						{
							if(0 == flag)
							{//无积水量计算
								yjWaterList += yjList[i] + ";";
							}
							else
							{//有积水量计算
								yjWaterList += yjList[i] + "|" + WaterAcc[waterCnt] + ";";
								waterCnt ++;
							}
						}
						else
						{//遍历到一个新的子系统			
							waterCnt = 0;
							SysId = yjList[i].substring(0,5);
							if(Func_Type_Id.indexOf(SysId) >= 0)
							{//该子系统有积水量计算
								<%
								if(WaterAcc != null)
								{
									Iterator roleiter = WaterAcc.iterator();
									while(roleiter.hasNext())
									{
										WaterAccBean roleBean = (WaterAccBean)roleiter.next();
										String SysId = roleBean.getSysId();
										String Water = roleBean.getWater();
										String TimePeriod = roleBean.getTimePeriod();
										String Status = roleBean.getStatus();
										%>
										if('<%=Status%>' == '0') 
										{
											if(SysId == '<%=SysId%>' && Time == '<%=TimePeriod%>')
											{
												WaterAcc = '<%=Water%>'.split("|");
												flag = 1;
												yjWaterList += yjList[i] + "|" + WaterAcc[waterCnt] + ";";
												waterCnt ++;
											}
										}else
										{
											if('<%=SysId%>'.split(",")[1] == "NumberFormat")
											{
												message = "子系统[" + '<%=SysId%>'.split(",")[0] + "]文档有误,在第[" + '<%=SysId%>'.split(",")[2] + "]行";
											}
											else if('<%=SysId%>'.split(",")[1] == "ArrayIndexOut")
											{
												message = "子系统[" + '<%=SysId%>'.split(",")[0] + "]数据有误,无法计算！数组越界！";
											}
											else if('<%=SysId%>'.split(",")[1] == "unknown")
											{
												message = "子系统[" + '<%=SysId%>'.split(",")[0] + "]数据有误,无法计算！未知错误！";
											}
										}
										<%
									}
								}
								%>
								
							}
							else
							{//该子系统无积水量计算	
								flag = 0;
								yjWaterList += yjList[i] + ";";
							}
						}
					}
					if(message.length > 0)
					{
						alert(message);
					}
					//将组合好的数据放到地图上显示
					if(yjWaterList.length > 0)
					{
      			//1.删除
						map.clearOverlays();
						//2.添加
						var gjList = yjWaterList.split(";");
		      	for(var i=0; i<gjList.length; i++)
		      	{
	      		  var sublist = gjList[i].split("|");
							if('00000' != document.getElementById("Func_Type_Map_Id").value)
							{
								if(sublist[0].substring(0,5) != document.getElementById("Func_Type_Map_Id").value)
									continue;
							}
	  		  	  var point = new BMap.Point(sublist[1], sublist[2]);
	      		  var gjObj = new Object();
	      		  gjObj.tId = sublist[0];
	      		  gjObj.tPoint = point;
	      		  gjArray.push(gjObj);
	      		  var water = 'none';
	      		  if(null != sublist[4])
	      		  {
	      		  	water = sublist[4];
	      		  }
							addGJMarker(point, sublist[0], sublist[0], sublist[3], water);
						}
					}
      	}
	    }
	  }
	};
	var TimePeriod = document.getElementById("Time").value;
	var url = "Analog_ToPo_GJ.do?Cmd=22&Id=<%=Project_Id%>&Sid=<%=Sid%>&Func_Sub_Type_Id=" + Func_Sub_Type_Id + "&Func_Type_Id=" + Func_Type_Id + "&currtime="+new Date();
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
	      		
	      		if('00000' != document.getElementById("Func_Type_Map_Id").value)
						{
							var ftmi = "WJ" + sublist[0].substring(2,5);
							if(ftmi != document.getElementById("Func_Type_Map_Id").value)
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
      		  addGXMarker(polyline,gxId,gjStartId);
	      	}
	      }
	    }
	  }
	};
	var url = "User_ToPo_GX.do?Cmd=21&Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}

//子系统号监控
function RealFileName()
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
	      	var list = Resp.substring(4).split(",");
	      	var HTML = "<option value='00000'  <%=Func_Type_Map_Id.equals(00000)?"selected":""%>  >所有</option>";
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		if(list[i].substring(0,2) == 'WJ')
	      		{
	      			HTML += "<option value=" + list[i] + "  <%=Func_Type_Map_Id.equals(" + list[i] + ")?"selected":""%>  >" + list[i] + "</option>";
	      		}
	      	}
	      	document.getElementById("Func_Type_Map_Id").innerHTML = HTML;
	      }
	    }
	  }
	};
	var url = "FileName_ToPo_GJ.do?Id=<%=Project_Id%>&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}
RealFileName();
RealStatus();
  	
function RealStatus()
{
	RealGJStatus();
	RealGXStatus();
	//RealFileName();
}

//左点击查看接口
var reqInfo = null;
function doGJDefence(pId, pType)
{
	var dUrl = '';
	var Func_Type_Id = document.getElementById("Func_Type_Map_Id").value;
	var TimePeriod = document.getElementById("Time").value;
	
	if(pType == 'none')
	{
		dUrl = "User_DevGJ_Info.do?Sid=<%=Sid%>&Cmd=3&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>&Id="+pId;
	}
	else
	{
		dUrl = "Analog_DevGJ_Info.do?Sid=<%=Sid%>&Cmd=3&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>&TimePeriod=" + TimePeriod + "&Id="+pId;
	}
	
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
    onBeforeClose:function(){
			$('#win').window('close', true);//这里调用close 方法，true 表示面板被关闭的时候忽略onBeforeClose 回调函数。
    }
	});
	
	/**
	var Pdiag = new Dialog();
	Pdiag.resizable = true;
	Pdiag.Top = "100%";
	Pdiag.Left = "100%";
	Pdiag.Width = 500;
	Pdiag.Height = 300;
	Pdiag.Title = "管井编码: "+pId;
	Pdiag.URL = dUrl;
	Pdiag.CancelEvent=function()
	{
		Pdiag.close();	//关闭窗口
//			RealStatus();		//页面刷新
	};
	Pdiag.show();
		
	//}	*/
}

//左点击查看管线接口
function doGXDefence(pId,gjId)
{
	var dUrl = "Analog_DevGX_Info.do?Cmd=0&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>&gxId="+pId+"&gjId="+gjId;
	
	$('#win').window({
		title: '管线编码:'+pId,
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
    onBeforeClose:function(){
			$('#win').window('close', true);//这里调用close 方法，true 表示面板被关闭的时候忽略onBeforeClose 回调函数。
    }
	});
}

//上传数据表格
function doAnalog_Import()
{	
	if(Analog_rainfall.file.value.Trim().length > 0)
  {
  	if(Analog_rainfall.file.value.indexOf('.xls') == -1 
  	&& Analog_rainfall.file.value.indexOf('.XLS') == -1 )	
		{
			alert('请确认文档格式,支持xls!');
			return;
		}else if(confirm('信息无误,确定提交?'))
	  {
				Analog_rainfall.submit();
			//Admin_Import_GJ.submit();
	  }
	}
}

//删除数据表格
function doDeleteData()
{
	var GJId = document.getElementById("Func_Type_Map_Id").value;
	if(GJId == 0000)
	{
		alert("不能删除所有数据，请单个删除!");
		return;	
	}
	if(confirm('确定删除当前子系统数据?'))
	{
		location = "DeleteData.do?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&Id="+GJId;
	}
}


//开始动态演示
var iTime;
function doStart()
{
	document.getElementById("start").style.display = "none";
	document.getElementById("stop").style.display = "";
	var time = document.getElementById("Time").value;	
  time = time*1 + 1;  
	document.getElementById("Time").value = time;
	RealStatus();	
	iTime = setTimeout(doStart,1000);
  if(time >= 24)
  {
  	doStop();	
  	return;
  }
	
}
//停止动态演示
function doStop()
{
	document.getElementById("start").style.display = "";
	document.getElementById("stop").style.display = "none";
	clearTimeout(iTime);
	return;
}

</SCRIPT>
</html>