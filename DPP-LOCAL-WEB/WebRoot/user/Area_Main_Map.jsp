<%@ page contentType="text/html; charset=gbk" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="rmi.*" %>
<%@ page import="util.*" %>
<%@page import="java.awt.*, java.awt.image.*, java.io.*, com.sun.image.codec.jpeg.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>城基排水管网信息管理平台</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>

<link rel="icon" type="image/png" href="../skin/images/logo_58.png">
<link rel="apple-touch-icon" href="../skin/images/logo_57.png" />
<link href="../skin/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../skin/js/one.js"></script>
<script type="text/javascript" src="../skin/js/md5.js"></script>
<script type='text/javascript' src='../skin/js/util.js'></script>


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
	

  //获取唯一Sid
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);

	UserInfoBean User_Info      = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList    Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	ArrayList    Mangage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	
	String User_Manage_Role = "";
	if(null != User_Info)
	{
		User_Manage_Role = User_Info.getManage_Role();
	}
	String User_Manage_List = "";
	String Project_List = "";
	String initZoomX = "";
	String initZoomY = "";
	String initZoomLev = "";
	if(Mangage_Role != null)
	{
		Iterator iterator = Mangage_Role.iterator();
		while(iterator.hasNext())
		{
			UserRoleBean statBean = (UserRoleBean)iterator.next();
			String Id = statBean.getId();
			String Point = statBean.getPoint();
			if(User_Manage_Role.length() < 8)
			{
				if(Id.length() == 8 && Id.contains(User_Manage_Role))
				{
					User_Manage_List += Point;
				}
			}else
			{
				User_Manage_List = Point;	
			}
			
			//取到第一次显示时的地图经纬度和倍数
			if(User_Manage_Role.substring(0,4).equals(Id)){
				initZoomX = statBean.getZoomX();
				initZoomY = statBean.getZoomY();
				initZoomLev = statBean.getZoomLev();
			}
			
		}
	}
	
  
%>
<body onload="MM_preloadImages('skin/images/d1_down.gif','skin/images/c1_down.gif')"  bgcolor="#085F9C">
	<div id="container"  >	</div>
	
	<input type="button"   id="CurrButton" onClick="doSelect()" style="display:none">
</body>
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

	var map = new BMap.Map("container");                        //创建地图实例
	//载入地图
	//map.setMapType(BMAP_HYBRID_MAP);                          //默认类型为卫星、路网一体
	map.centerAndZoom(new BMap.Point(<%=initZoomX%>, <%=initZoomY%>), <%=initZoomLev%>);   //初始化地图，设置中心点坐标和地图级别
	//map.addControl(new BMap.NavigationControl());            	//添加一个平移缩放控件，位置可偏移、形状可改变
	map.addControl(new BMap.ScaleControl());                    //添加一个比例尺控件，位置可偏移[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
	map.addControl(new BMap.OverviewMapControl());              //添加一个缩略图控件，位置可偏移
	//map.addControl(new BMap.MapTypeControl());                //添加地图类型变换(地图-卫星-三维)，位置可偏移
	map.enableScrollWheelZoom();                                //启用滚轮放大缩小
	
	
var User_Project_List = '<%=Project_List%>'.split(",");
	
function doSelect()
{
	var ZoomX = window.parent.frames.lFrame.document.getElementById('ZoomX').value;
	var ZoomY = window.parent.frames.lFrame.document.getElementById('ZoomY').value;
	var ZoomLev = window.parent.frames.lFrame.document.getElementById('ZoomLev').value;
	map.centerAndZoom(new BMap.Point(ZoomX, ZoomY), ZoomLev*1);
	
	var	ProjectList = "";
	ProjectList = window.parent.frames.lFrame.document.getElementById('ProjectList').value;
	if(ProjectList != null && ProjectList.length > 0)
	{
	//1.删除
	map.clearOverlays();
	<%
		if(Project_Info != null)
		{
			Iterator iterator = Project_Info.iterator();
			while(iterator.hasNext())
			{
				ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
				String Id = statBean.getId();
				String CName = statBean.getCName();
				String Longitude = statBean.getLongitude();
				String Latitude = statBean.getLatitude();
				%>
				if(('<%=User_Manage_List%>'.indexOf('<%=Id%>') >= 0) && (ProjectList.indexOf('<%=Id%>') >= 0))
				{
					doAddMarker('<%=Id%>', '<%=CName%>', '<%=Longitude%>', '<%=Latitude%>');
				}
				<%
			}
		}
	%>
	}
}

function doAddMarker(pId, pCName, pX, pY)
{
	var pIcon  = '../skin/images/project_choose.gif';
	var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
 	var marker = new BMap.Marker(new BMap.Point(pX, pY), {icon: myIcon});
 	var myLabel= new BMap.Label(pCName, {offset:new BMap.Size(0, pY)});
 	myLabel.setStyle
 	({
 		fontSize:"13px",
 		border:"0px",
 		color:"#0074c1",
 		textAlign:"center",
 		background:"#FFFFFF",
 		cursor:"pointer"
 	});
 	marker.setLabel(myLabel);//文字标记
 	//marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳跃动画
 	map.addOverlay(marker);

  //点击
 	marker.addEventListener("click", function()
 	{
 		doUserMap(pId);
	});
}

function doUserMap(Id)
{
	window.parent.location.href='MapMain.jsp?Sid=<%=Sid%>&Project_Id='+Id;
}

</script>
</body>
</html>