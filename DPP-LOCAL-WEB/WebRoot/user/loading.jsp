<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>点击管井信息显示</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String Project_Id  = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	String AnalogType  = CommUtil.StrToGB2312(request.getParameter("AnalogType"));

%>
<body style=" background:#F5F3F0">
<div>
	<table width="100%">
		<br><br><br><br><br>		    	
		<tr align='center'>
			<td align='center'>正在加载，请等待...</td>
	</table>	
</div>

<input type="button" id="_ButtonOK_0" style="display:none;">
</body>
<SCRIPT LANGUAGE=javascript>

if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

var Func_Sub_Type_Id = "";

//注释掉两个模拟
function unAnalog()
{
	if('<%=Project_Id%>' == '000001' || '<%=Project_Id%>' == '000002')
	{
		alert("待开通！");
		history.go(-1);
		return;
	}
	else
	{
		doPrompt();
	}
}
unAnalog();
function doPrompt()
{
	if('<%=AnalogType%>' == 'YJ')
	{
		prompt_YJ();
	}
	else
	{
		prompt_WJ();
	}
}

//输入降雨强度重现期
function prompt_YJ()
{
  var input = prompt("请输入降雨强度重现期年限:(可输入的值为:0.5,1,2,3,5,10,50,100)","5")
  if (!isNaN(input))
  {
  	if(input == 0.5 || input == 1 || input == 2 || input == 3 || input == 5 || input == 10 || input == 50 || input == 100)
  	{
  		Func_Sub_Type_Id = input;
  	}
  	else
  	{
  		alert("您输入的值不正确，可输入的值为:0.5,1,2,3,5,10,50,100");
  		prompt_YJ();
  	}
  }
	else
	{
		alert("您输入不是数字，请重新输入！");
		prompt_YJ();
	}
	doAnalog();
}
//输入人均排水量
function prompt_WJ()
{
	var input = prompt("请输入人均排水量:(可输入的值为:0.3,0.45,0.5,0.8,1.0(M3/cap.d))","0.45")
  if (!isNaN(input))
  {
  	if(input == 0.3 || input == 0.45 || input == 0.5 || input == 0.8 || input == 1.0)
  	{
  		Func_Sub_Type_Id = input;
  	}
  	else
  	{
  		alert("您输入的值不正确，可输入的值为:0.3,0.45,0.5,0.8,1.0");
  		prompt_WJ();
  	}
  }
	else
	{
		alert("您输入不是数字，请重新输入！");
		prompt_WJ();
	}
	doAnalog();
}
	
function doAnalog()
{
	window.parent.frames.mFrame.location = 'Analog_WaterAcc.do?Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&Func_Type_Id=<%=AnalogType%>&Func_Sub_Type_Id=' + Func_Sub_Type_Id;
}

</SCRIPT>
</html>