<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Project_Id = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Fp_Role = (ArrayList)session.getAttribute("User_Fp_Role_" + Sid);
	ArrayList User_Manage_Role = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);

	//功能权限
	String CName = "";	
	String FpId = "";
	String ManageId = "";
	if(null != UserInfo)
	{
		CName = UserInfo.getCName();
		FpId = UserInfo.getFp_Role();
		ManageId = UserInfo.getManage_Role();
	}
	String FpIdName = "";
	String FpList = "";
	if(null != FpId && FpId.length() > 0 && null != User_Fp_Role)
	{
		Iterator roleiter = User_Fp_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
				FpIdName = roleBean.getCName();
			}
		}
	}
	String logoSrc = "../skin/images/logo_sub_project_" + Project_Id + ".gif";
	if(Project_Id.equals("900009") || Project_Id.equals("000003"))
	{
		logoSrc = "../skin/images/logo_sub_system_manage.gif";
	}
	
	//管理权限
	
	String ManageName = "";
	if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
	{
		Iterator roleiter = User_Manage_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(ManageId))
			{
				ManageName = roleBean.getCName();
			}
		}
	}
	%>
<title>百事达排水管网信息管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>

<body>		
	<div class="top">
		<div class="logo"><img src="<%=logoSrc%>" /></div>
		<div class="home" style="cursor:hand"><img onClick="doHome()" src="../skin/images/home.gif" /></div>
		<div class="exit" style="cursor:hand"><img onClick="doExit()" src="../skin/images/exit.gif" /></div>
		<div class="bar">
			<!--开会时注释掉，方便投影仪显示-->
			<div class="ren"><img onClick="doPwd()" width="18" height="15" style="cursor:hand" src="../skin/images/top_user_pwd.gif"  alt="密码修改"/> <img onClick="doInfo()" style="cursor:hand" src="../skin/images/ren.gif" width="13" height="15" alt="个人信息" /></div>
			<div class="js">您好: <%=CName%> [功能权限: <font color=green><%=FpIdName%></font> | 管理权限: <font color=green><%=ManageName%></font>]</div>
			<div class="line"><img src="../skin/images/bar_line.gif" /></div>
			<div class="js2" id="time"></div>
			<div id="banner_r" class="js">
				<img onClick="doGIS()"     style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='01' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_gw.gif"     			alt="管网地图"/> 
				<img onClick="doGJ_Info()"    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='02' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_gj.gif"     	alt="管井列表"/>
				<img onClick="doGX_Info()"    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='03' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_gx.gif"     	alt="管线列表"/>
				<img onClick="doImport_Excel()" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='04' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_import.gif" alt="管线导入"/>	
				<img onClick="doGIS_GJ()" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='05' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_mark.gif"  				alt="地图标注"/>
				<img onClick="Analog_Water()" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='06' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_analog.gif"   alt="降雨模拟"/>
				<img onClick="Analog_Sewage()" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='07' ctype='1'/>; cursor:hand" src="../skin/images/top_menu_sewage.gif"  alt="污水模拟"/>
			</div>			
		</div>
	</div>
</body>
<SCRIPT LANGUAGE=javascript>
setInterval("time.innerHTML= new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);
//setInterval("time.innerHTML= new Date().toLocaleString().substring(0, new Date().toLocaleString().indexOf('日')+1)",1000);

	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='01' ctype='1'/>' == '')
	{
		window.parent.frames.mFrame.location = 'User_Main_Map.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>';
	}else{
		window.parent.frames.mFrame.location = 'User_Info.jsp?Sid=<%=Sid%>';
	}

function doHome()
{
		window.parent.location = "../project_choose.jsp?Sid=<%=Sid%>";
}

function doExit()
{
    if(confirm("确定要安全退出本系统?"))
    {
      alert("谢谢您的使用!");
			location = "ILogout.do?Sid=<%=Sid%>";
		}
}

function doInfo()
{
	window.parent.frames.mFrame.location = "User_Info.jsp?Sid=<%=Sid%>";
}

function doPwd()
{
	window.parent.frames.mFrame.location = "User_Pwd.jsp?Sid=<%=Sid%>";
}
//
function doDiaphic()
{	
	window.parent.frames.mFrame.location = "Diapgic.do?Sid=<%=Sid%>&Cmd=4&Subsys_Id=001&Project_Id=<%=Project_Id%>";
}
function doGIS()
{
	window.parent.frames.mFrame.location = 'User_Main_Map.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>';
}
function doGJ_Info()
{
	window.parent.frames.mFrame.location = 'User_DevGJ_Info.do?Cmd=1&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>';
}
function doGX_Info()
{
	window.parent.frames.mFrame.location = 'User_DevGX_Info.do?Cmd=1&Sid=<%=Sid%>&Func_Project_Id=<%=Project_Id%>&Func_Sort_Id=01';
}
function doImport_Excel()
{	
	var project = <%=Project_Id%>+"";
	if(project.substr(0,1) != 9)
	{
		if(confirm("这是原始数据，请慎重修改！"))
		{
			window.parent.frames.mFrame.location = 'Import_Excel.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>';
		}
	}else{
		window.parent.frames.mFrame.location = 'Import_Excel.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>';
	}
}
function doGIS_GJ()
{	
	var project = <%=Project_Id%>+"";
	if(project.substr(0,1) != 9)
	{
		if(confirm("这是原始数据，请慎重修改！"))
		{
			window.parent.frames.mFrame.location = 'User_Map_GJ.jsp?Project_Id=<%=Project_Id%>&Sid=<%=Sid%>';
		}
	}else{
		window.parent.frames.mFrame.location = 'User_Map_GJ.jsp?Project_Id=<%=Project_Id%>&Sid=<%=Sid%>';
	}
}
function Analog_Water()
{
	window.parent.frames.mFrame.location = 'loading.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&AnalogType=YJ';
}
function Analog_Sewage()
{
	window.parent.frames.mFrame.location = 'loading.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&AnalogType=WJ';
}



</SCRIPT>
</html>