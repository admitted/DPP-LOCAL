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
	String Id 								= CommUtil.StrToGB2312(request.getParameter("Id"));
	String Project_Id					= CommUtil.StrToGB2312(currStatus.getFunc_Project_Id());  
	String TimePeriod         = CommUtil.StrToGB2312(request.getParameter("TimePeriod"));
	String       Time         = CommUtil.StrToGB2312(request.getParameter("Time"));

	DevGJBean User_DevGJ_Info = (DevGJBean)session.getAttribute("User_DevGJ_Info_" + Sid);
 
  String Curr_Data = "";
	String Material = "";
	String Base_Height = "";
	String Top_Height = "";
	String Size = "";
	String Flag ="";
  
  if(User_DevGJ_Info != null)
  {
	  Curr_Data 	= User_DevGJ_Info.getCurr_Data();
		Material 		= User_DevGJ_Info.getMaterial();
		Base_Height = User_DevGJ_Info.getBase_Height();
		Top_Height 	= User_DevGJ_Info.getTop_Height();
		Size 				= User_DevGJ_Info.getSize();
		Flag        = User_DevGJ_Info.getFlag();
  }

	%>
</head>
<body >
<form name='Abalog_DevGJ_Info'   method='post' target='mFrame'>
<div>
	<table style='margin:auto'    border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
			<tr height='30' valign='bottom'>
					<td width='24%' align='center'>
				      <select name='GraphType' style='width:110px;height:20px' onChange='doGraphType()'>
				      	<!--<option value='0'>窨井图</option>-->
				      	<%
				      	if(Flag.equals("2"))
				      	{
				      	%>
				        	<option value='2'>时段水位图</option>	
				        <%
				      	}else
				      	{
				      	%>
				      		<option value='1'>剖面图(有水位)</option>
				        	<option value='2'>时段水位图</option>	
				      	<%
				      	}
				        %>			      
				      </select>
				  </td>
					<td width='80%' align='left' 	>
						顶高: <%=Top_Height%>&nbsp;
						底高: <%=Base_Height%>&nbsp;
						尺寸：<%=Size%>&nbsp;
						材质: <%=Material%>&nbsp;
				  	<div id='selectTime1' style='display:;position:absolute;width:40px;height:20px;right:52px;top:40px;'>
				  		<%
				  		if(Id.contains("WJ"))
				  		{
				  		%>
							<select id="Time1" name="Time1" style="width:100%;height:20px;" onChange="doWater()">
								<%
								for(int i = 1; i <= 48; i ++){
								%> 									  
								<option value='<%=i%>' <%=Time.equals(String.valueOf(i))?"selected":""%>   > <%=i%></option>
								<%
								}
								%>		
							</select>
							<%
							}else
							{
								%>
								<select id="Time1" name="Time1" style="width:100%;height:20px;" onChange="doWater()">
								<%
								for(int i = 1; i <= 60; i ++){
								%> 									  
								<option value='<%=i%>' <%=Time.equals(String.valueOf(i))?"selected":""%>   > <%=i%></option>
								<%
								}
								%>		
							</select>
								<%
							}
							%>
						</div>
						<div id="start1"  style='display:;position:absolute;width:30px;height:23px;right:20px;top:40px;'>
					  	<input type="button" value="播放" onClick="doStart1()" />
					  </div>
					  <div id="stop1"  style='display:none;position:absolute;width:30px;height:23px;right:20px;top:40px;'>
					  	<input type="button" value="停止" onClick="doStop1()" />
					  </div>
				  	</div>
						
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
<input name="Id" type="hidden" value="<%=Id%>">
</form>

<SCRIPT LANGUAGE=javascript>
function doGraphType()
{
	if(0 == Abalog_DevGJ_Info.GraphType.value)
	{
		showNothing();
	}
	else if(1 == Abalog_DevGJ_Info.GraphType.value)
	{
		showCutGraph();
	}
	else if(2 == Abalog_DevGJ_Info.GraphType.value)
	{
		showCurveGraph();
	}
}

function showNothing()
{
	document.getElementById("ifrPage").src  = "User_GJ_Scene.jsp?Sid=<%=Sid%>&GJ_Id=<%=Id%>&Project_Id=<%=Project_Id%>";
	document.getElementById("selectTime1").style.display = "none";
	document.getElementById("start1").style.display = "none";
	document.getElementById("stop1").style.display = "none";	
}
//剖面图
function showCutGraph()
{
	var time = Abalog_DevGJ_Info.Time1.value;
	document.getElementById("ifrPage").src  = "Analog_Graph_Cut.do?Sid=<%=Sid%>&Cmd=4"
	+ "&Func_Id=0&Id=<%=Id%>&Func_Project_Id=<%=Project_Id%>"
	+ "&TimePeriod=" + time
	+ "&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>";
	
	document.getElementById("selectTime1").style.display = "";
	document.getElementById("start1").style.display = "";
	document.getElementById("stop1").style.display = "none";
}
//折线图
function showCurveGraph()
{
	document.getElementById("ifrPage").src  = "Analog_Graph_Curve.do?Cmd=4&Sid=<%=Sid%>&GJ_Id=<%=Id%>&Func_Project_Id=<%=Project_Id%>&Func_Sub_Type_Id=<%=currStatus.getFunc_Sub_Type_Id()%>";
	
	document.getElementById("selectTime1").style.display = "none";
	document.getElementById("start1").style.display = "none";
	document.getElementById("stop1").style.display = "none";
}

//开始动态演示
var iTime;
function doStart1()
{
	document.getElementById("start1").style.display = "none";
	document.getElementById("stop1").style.display = "";
	var time = document.getElementById("Time1").value;
	time = time*1 + 1;
	document.getElementById("Time1").value = time;
	doWater();
	if('<%=Id%>'.indexOf("WJ") >= 0)
	{
		if(time >= 24)
	  {
	  	doStop1();
	  	return;
	  }
	}
	else
	{
		if(time >= 60)
	  {
	  	doStop1();
	  	return;
	  }
	}
	iTime = setTimeout(doStart1,1500);
}
//停止动态演示
function doStop1()
{
	document.getElementById("start1").style.display = "";
	document.getElementById("stop1").style.display = "none";
	clearTimeout(iTime);
	return;
}
doStop1();

//调用剖面图当中的doYesWater方法
function doWater()
{
	var time = (Abalog_DevGJ_Info.Time1.value)-1;
	window.ifrPage.doYesWater(time);
}

doGraphType()
</script>

</body>

</html>