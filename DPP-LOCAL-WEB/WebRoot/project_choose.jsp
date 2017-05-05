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
<link rel="icon" type="image/png" href="skin/images/logo_58.png">
<link rel="apple-touch-icon" href="skin/images/logo_57.png" />
<link href="skin/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="skin/js/one.js"></script>
<script type="text/javascript" src="skin/js/md5.js"></script>
<script type='text/javascript' src='skin/js/util.js'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<style>
  html,body{width:100%; height:100%; margin:0; padding:0;}
  .mesWindow{border:#358ee1 3px solid;background:#f0f5f0;}
  .mesWindowTop{display:none;background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{display:none;position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}
</style>
</head>
<%
  String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  
  ArrayList Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
  UserInfoBean UserInfo      = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  ArrayList    Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
  
  String Manage_Role_Id = "";
  if(UserInfo != null)
  {
  	Manage_Role_Id = UserInfo.getManage_Role();
  }
  String R_Point="";
  if(Manage_Role != null)
	{
		Iterator iterator = Manage_Role.iterator();
		while(iterator.hasNext())
		{
			UserRoleBean statBean = (UserRoleBean)iterator.next();
			String Id = statBean.getId();
			String Point = statBean.getPoint();
			if(Id.equals(Manage_Role_Id))
			{
				R_Point = Point;
			}
		}
	}
	int sn = 0;
%>

<body onload="MM_preloadImages('skin/images/d1_down.gif','skin/images/c1_down.gif')"  bgcolor="#085F9C">
<form  name="login" action="Login.do"  method="post" target="_self">
<div class="center">
<div class="top1">
	<div><img src="skin/images/logoV2.jpg" /></div>
	<div class="top3">
		<div class="top5" >
			<div style="padding-top:50px;padding-left:200px;">
	  	<%
	  	if(Project_Info != null)
			{
				Iterator iterator = Project_Info.iterator();
				while(iterator.hasNext())
				{
					ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
					String Id = statBean.getId();
					String CName = statBean.getCName();
					if(R_Point.contains(Id))
					{
						sn ++;
				%>
						<a href="user/User_Main.jsp?Sid=<%=Sid%>&Project_Id=<%=Id%>" ><U><%=CName%></U></a>
				<%
						if(sn % 4 == 0)
						{
						%>
							<br>
						<%
						}
					}
				}
			}
	  	
	  	%>
	  	<br>
			<br>
			<!--<a href="user/User_OL_Map.jsp"><U>华家池高清</U></a>-->
	  	
	  	</div>
		</div>
	</div>
	<div><img src="skin/images/t4.gif" /></div>
</div>
</div>
<input type="hidden" name="Old_Pwd" value="">
<input type="hidden" name="New_Pwd" value="">
<input type="hidden" name="User_Id" value="">
<input type="hidden" name="Cmd" value="21">
<input type="hidden" name="StrMd5" value="">
<input type="hidden" name="Sid" value="<%=Sid%>">
</form>


<SCRIPT LANGUAGE=javascript>

</script>
</body>
</html>