<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="rmi.*" %>
<%@ page import="util.*" %>
<%@page import="java.awt.*, java.awt.image.*, java.io.*, com.sun.image.codec.jpeg.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Project_Id = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	String p3  = CommUtil.StrToGB2312(request.getParameter("p3"));
	
	ArrayList User_Fp_Role = (ArrayList)session.getAttribute("User_Fp_Role_" + Sid);
	
	//功能权限
	/**
	String FpId = UserInfo.getFp_Role();
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
	}**/
	
  if(null == p3)
	{
		p3 = "1";
	}
	%>
<title>城基排水管网智能管理平台</title>
<link rel="icon" type="image/png" href="../skin/images/logo_58.png">
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<!--MapMain_Map.jsp?Sid=<%=Sid%>&p3=<%=p3%>&Project_Id=<%=Project_Id%>-->
</head>
<frameset rows="111,*" cols="*" frameborder="NO" border="0" framespacing="0px">
	<frame src="User_Main_top.jsp?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>" name="tFrame" scrolling="NO" noresize>
		<frameset id="glb_frm"  rows="*"  framespacing="0px" frameborder="NO" border="0">
			<frame src="" id="mFrame"  name="mFrame"  frameborder="no" scrolling="auto" noResize>
		</frameset>
</frameset>

</html>