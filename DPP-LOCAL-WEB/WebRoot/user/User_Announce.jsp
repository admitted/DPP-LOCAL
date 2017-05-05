<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>¹Ü¾®±ê×¢</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CorpInfoBean User_Announce = (CorpInfoBean)session.getAttribute("User_Announce_" + Sid);
	String Demo = "";
	if(User_Announce != null)
	{
		Demo = User_Announce.getDemo();
  	if(Demo == null){Demo = "";}
 	}

%>
<body>
	
	<%=Demo%>
	
</body>
</html>