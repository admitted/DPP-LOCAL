<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>百事达排水管网信息管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<link rel="stylesheet" href="../skin/css/zTreeStyle2.css" type="text/css">
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="../skin/js/jquery.ztree.core-3.4.js"></script>
<script type="text/javascript" src="../skin/js/jquery.ztree.excheck-3.4.js"></script>
<script type="text/javascript" src="../skin/js/jquery.ztree.exedit-3.4.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  ArrayList User_Manage_Role = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
  ArrayList Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
  UserInfoBean UserInfo      = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  
	String Project_List = "";
	String ManageId = "";
	if(null != UserInfo)
	{
		ManageId = UserInfo.getManage_Role();
	}
	
%>
<body style="background:#0B80CC;">
	<div><ul id="proTree" class="ztree"></ul></div>
	<div id='CurrJsp' style='display:none'>Pro_I.jsp</div>
	<input type='hidden' id='id' name='id' value=''>
	<input type='hidden' id='level' name='level' value=''>
	<input type='hidden' id='ZoomX' name='ZoomX' value=''>
	<input type='hidden' id='ZoomY' name='ZoomY' value=''>
	<input type='hidden' id='ZoomLev' name='ZoomLev' value=''>
	<input type='hidden' id='ProjectList' name='ProjectList' value=''>
</body>
<SCRIPT LANGUAGE=javascript>
//树操作
var provinceValue = '';
var cityValue = '';
var areaValue = '';
var ProjectList = '';
var rootseq = 0;
var Nodes1 = [];
var setting = 
{
  edit: 
  {
    enable: false
  },
  data: 
  {
    simpleData:{enable: true}
  },
  callback: 
  {
    onClick: zTreeOnClick
  }
};

<%
if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
{
	Iterator iterator = User_Manage_Role.iterator();
	String R_Point_list = "";
	while(iterator.hasNext())
	{
		UserRoleBean statBean = (UserRoleBean)iterator.next();
		if(statBean.getId().substring(0,4).equals(ManageId.substring(0,4)))
		{
			String R_Id = statBean.getId();
			String R_CName = statBean.getCName();
			String R_Point = statBean.getPoint();
			String R_ZoomX = statBean.getZoomX();
			String R_ZoomY = statBean.getZoomY();
			String R_ZoomLev = statBean.getZoomLev();
			if(null == R_CName){R_CName = "";}
			if(null == R_Point){R_Point = "";}
			
			switch(R_Id.length())
			{
				case 4:
%>
						provinceValue = '<%=R_ZoomX%>,' + '<%=R_ZoomY%>,' + '<%=R_ZoomLev%>';
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id%>', ZoomX:'<%=R_ZoomX%>', ZoomY:'<%=R_ZoomY%>', ZoomLev:'<%=R_ZoomLev%>', isParent:true, open:true, icon:'../skin/images/root.png'};
						Nodes1.push(node);
<%
					break;
				case 6:
%>
						cityValue = '<%=R_ZoomX%>,' + '<%=R_ZoomY%>,' + '<%=R_ZoomLev%>';
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id.substring(0,4)%>', ZoomX:'<%=R_ZoomX%>', ZoomY:'<%=R_ZoomY%>', ZoomLev:'<%=R_ZoomLev%>', isParent:true, open:true};
						Nodes1.push(node);
<%
					break;
				case 8:
%>
						areaValue = '<%=R_ZoomX%>,' + '<%=R_ZoomY%>,' + '<%=R_ZoomLev%>';
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id.substring(0,6)%>', ZoomX:'<%=R_ZoomX%>', ZoomY:'<%=R_ZoomY%>', ZoomLev:'<%=R_ZoomLev%>', isParent:true, open:true};
						Nodes1.push(node);
<%
					break;
			}
			if(R_Point.trim().length() > 0)
			{
				String[] list = R_Point.split(",");
				for(int i=0; i<list.length && list[i].trim().length() > 0; i++)
				{
					//站点信息
					if(Project_Info != null)
					{
						Iterator iterator2 = Project_Info.iterator();
						while(iterator2.hasNext())
						{
							ProjectInfoBean Bean = (ProjectInfoBean)iterator2.next();
							if(Bean.getId().equals(list[i]))
							{
								String Id = Bean.getId();
								String CName = Bean.getCName();
								String Longitude = Bean.getLongitude();
								String Latitude = Bean.getLatitude();
%>
								ProjectList += '<%=Id%>' + ',';
								var node = {id:'<%=Id%>', name:'<%=CName%>', value:'<%=Id%>', pId:'<%=R_Id%>', isParent:false, open:false};
								Nodes1.push(node);
<%
							}
						}
					}
				}
			}
		}
	}
}
%>

/*-----------------------------生成树----------------------------------*/
$('#proTree').empty();
$.fn.zTree.init($('#proTree'), setting, Nodes1);

/*-----------------------------点击树----------------------------------*/
function zTreeOnClick(event, treeId, treeNode)
{
	var ZoomX = '';
	var ZoomY = '';
	var ZoomLev = '';
	if(0 == treeNode.level)
	{
		if(provinceValue.length > 0)
		{
			var list = provinceValue.split(',');
			ZoomX = list[0];
			ZoomY = list[1];
			ZoomLev = list[2];
		}
		document.getElementById('ZoomX').value = ZoomX;
		document.getElementById('ZoomY').value = ZoomY;
		document.getElementById('ZoomLev').value = ZoomLev;
		document.getElementById('ProjectList').value = '';
	}
	else if(1 == treeNode.level)
	{
		if(cityValue.length > 0)
		{
			var list = cityValue.split(',');
			ZoomX = list[0];
			ZoomY = list[1];
			ZoomLev = list[2];
		}
		document.getElementById('ZoomX').value = ZoomX;
		document.getElementById('ZoomY').value = ZoomY;
		document.getElementById('ZoomLev').value = ZoomLev;
		document.getElementById('ProjectList').value = '';
	}else if(2 == treeNode.level)
	{
		var nodes = treeNode.child
		if(areaValue.length > 0)
		{
			var list = areaValue.split(',');
			ZoomX = list[0];
			ZoomY = list[1];
			ZoomLev = list[2];
		}
		document.getElementById('ZoomX').value = ZoomX;
		document.getElementById('ZoomY').value = ZoomY;
		document.getElementById('ZoomLev').value = ZoomLev;
		document.getElementById('ProjectList').value = ProjectList;
	}
	window.parent.frames.mFrame.document.getElementById('CurrButton').click();
	
	var x = document.getElementById('ZoomX').value;
	var y = document.getElementById('ZoomY').value;
	var l = document.getElementById('ZoomLev').value;
	var p = document.getElementById('ProjectList').value;
	//alert("ZoomX[" + x + "].ZoomY[" + y + "].ZoomLev[" + l + "].Project_Id[" + p + "]");
	
}


</SCRIPT>
</html>