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
<title>水位折线图</title>
<link   type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/jquery.min.js"></script>
<script type="text/javascript" src="../skin/js/highcharts.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>

<%
	String Sid   							= CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus 		= (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String gjId 							= CommUtil.StrToGB2312(request.getParameter("gjId"));
	String gxId 							= CommUtil.StrToGB2312(request.getParameter("gxId"));
	String Project_Id					= CommUtil.StrToGB2312(currStatus.getFunc_Project_Id());  

	DevGXBean Analog_DevGX_Info = (DevGXBean)session.getAttribute("Analog_DevGX_Info_" + Sid);
 
	String Diameter = "";
	String Length = "";
	String Start_Height = "";
	String End_Height = "";
	String Material = "";
  
  if(Analog_DevGX_Info != null)
  {
  	Diameter = Analog_DevGX_Info.getDiameter();
  	Length = Analog_DevGX_Info.getLength();
  	Start_Height = Analog_DevGX_Info.getStart_Height();
  	End_Height = Analog_DevGX_Info.getEnd_Height();
  	Material = Analog_DevGX_Info.getMaterial();
  }

	%>
</head>
<body >
<form name='Abalog_DevGX_Info'   method='post' target='mFrame'>
<div>
	<table style='margin:auto'    border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
			<tr height='30' valign='bottom'>
					<td width='24%' align='center'>
				      <select name='GraphType' style='width:110px;height:20px' onChange='doGraphType()'>
				      		<option value='1'>流量负荷</option>
				        	<option value='2'>实际流量</option>      
				        	<option value='3'>流速</option>  
				      </select>
				  </td>
					<td width='80%' align='left' 	>
						管径:<%=Diameter%>m
						长度:<%=Length%>m
						起端底高:<%=Start_Height%>m
						终点底高:<%=End_Height%>m
						材料:<%=Material%>&nbsp;
				  </td>
			</tr>
			<tr height='30' valign='bottom'>
		    	<td width='100%' align='center' colspan=2>
		      		<div id='externalHtml' style='width:100%;height:285px;margin-top:20px'>
		      			<iframe id="ifrPage" width='100%' height='100%' name="ifrPage" src="" framespacing="0px" frameborder="NO" border="0" scrolling="NO" noresize></iframe>	
		      		</div>
		    	</td>
		  </tr>	
  </table>
</div>
</form>

<SCRIPT LANGUAGE=javascript>
function doGraphType()
{
	if(1 == Abalog_DevGX_Info.GraphType.value)
	{
		showFlowLoad();
	}
	else if(2 == Abalog_DevGX_Info.GraphType.value)
	{
		showActualFlow();
	}
	else if(3 == Abalog_DevGX_Info.GraphType.value)
	{
		showFlowRate();
	}
}

function showFlowLoad()
{
	document.getElementById("ifrPage").src = "Analog_Graph_FlowLoad.do?Sid=<%=Sid%>&Cmd=1&gjId=<%=gjId%>&gxId=<%=gxId%>&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>";
}
//剖面图
function showActualFlow()
{
	document.getElementById("ifrPage").src = "Analog_Graph_ActualFlow.do?Sid=<%=Sid%>&Cmd=2&gjId=<%=gjId%>&gxId=<%=gxId%>&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>";
}
//折线图
function showFlowRate()
{
	document.getElementById("ifrPage").src = "Analog_Graph_FlowRate.do?Sid=<%=Sid%>&Cmd=3&gjId=<%=gjId%>&gxId=<%=gxId%>&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>";
}

doGraphType()
</script>

</body>

</html>