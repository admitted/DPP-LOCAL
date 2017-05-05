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
	String Id 								= request.getParameter("Id");
	String Project_Id					= CommUtil.StrToGB2312(currStatus.getFunc_Project_Id());  
	DevGJBean User_DevGJ_Info = (DevGJBean)session.getAttribute("User_DevGJ_Info_" + Sid);
 	
  String Curr_Data = "";
	String Material = "";
	String Base_Height = "";
	String Top_Height = "";
	String Size = "";
	String Equip_Height = "";
	String Flag = "";
	double WaterLev = 0.0;
	DecimalFormat df = new DecimalFormat("##.###");
  
  if(User_DevGJ_Info != null)
  {
	  Curr_Data 	= User_DevGJ_Info.getCurr_Data();
		Material 		= User_DevGJ_Info.getMaterial();
		Base_Height = User_DevGJ_Info.getBase_Height();
		Top_Height 	= User_DevGJ_Info.getTop_Height();
		Size 				= User_DevGJ_Info.getSize();
		Equip_Height= User_DevGJ_Info.getEquip_Height();
		Flag        = User_DevGJ_Info.getFlag();
		if(Curr_Data.trim().equals("0.00"))
		{
			WaterLev = 0.00;
		}else
		{
			WaterLev = Double.parseDouble(Top_Height) - Double.parseDouble(Equip_Height) + Double.parseDouble(Curr_Data);
		}
  }

	%>
</head>
<body borderColorDark='#ffffff'>
<form name='User_DevGJ_Info'   method='post' target='mFrame'>
<div>
	<table style='margin:auto'    border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
			<tr height='30' valign='bottom'>
				<td width='24%' align='center'>
			      <select name='GraphType' style='width:110px;height:20px' onChange='doGraphType()'>
			      	<option value='0'>窨井图</option>
			      	<%
			      	if(!Flag.equals("2"))
			      	{
			      	%>
				      	<option id="option1" style="display:;" value='1'>剖面图(无水位)</option>
				      	<option id="option2" style="display:;" value='2'>剖面图(有水位)</option>
				      <%
				      }
				      %>
			        <option value='3'>水位图</option>
			      </select>
			  </td>
				<td width='70%' align='left'>
					顶高: <%=Top_Height%>&nbsp;
					底高: <%=Base_Height%>&nbsp;
					尺寸：<%=Size%>&nbsp;
					材质: <%=Material%>&nbsp;
					水位: <%=df.format(WaterLev)%>&nbsp;
			  </td>
			  
			</tr>
			<tr height='30' valign='bottom'>
		    	<td width='100%' align='center' colspan=3>
		      		<div id='externalHtml' style='width:100%;height:285px;margin-top:20px'>
		      			<iframe id="ifrPage" width='100%' height=285px name="ifrPage" src="" framespacing="0px" frameborder="NO" border="0" scrolling="NO" noresize></iframe>	
		      		</div>
		    	</td>
		  </tr>
  </table>
</div>
<input name="Id" type="hidden" value="<%=Id%>">
</form>

<SCRIPT LANGUAGE=javascript>
//若是水位站，则影藏掉剖面图
if('<%=Id%>'.indexOf('SZ') >= 0)
{
	document.getElementById("option1").style.display='none';
	document.getElementById("option2").style.display='none';
}

function doGraphType()
{
	if(0 == User_DevGJ_Info.GraphType.value)
	{
		showInImg();
	}
	else if(1 == User_DevGJ_Info.GraphType.value)
	{
		showNothing()
		//showCutGraph();
	}
	else if(2 == User_DevGJ_Info.GraphType.value)
	{
		//showNothing()
		showCutGraph();
	}
	else if(3 == User_DevGJ_Info.GraphType.value)
	{
		showCurveGraph();
	}
}

function chageImgHeight(newWidth,newHeight)
{
	document.getElementById("externalHtml").style.width = newWidth;
	document.getElementById("externalHtml").style.height = newHeight;
}

function showInImg()
{
	document.getElementById("ifrPage").src = "User_GJ_Img.jsp?Sid=<%=Sid%>&GJ_Id=<%=Id%>&Project_Id=<%=Project_Id%>";
}

function showNothing()
{
	document.getElementById("ifrPage").src  = "User_Graph_Cut.do?Sid=<%=Sid%>&Cmd=4&Func_Id=1&Id=<%=Id%>&Func_Project_Id=<%=Project_Id%>";	
}

function showCutGraph()
{
	document.getElementById("ifrPage").src  = "User_Graph_Cut.do?Sid=<%=Sid%>&Cmd=4&Func_Id=2&Id=<%=Id%>&Func_Project_Id=<%=Project_Id%>";	
}

function showCurveGraph()
{
	document.getElementById("ifrPage").src  = "User_Graph_Curve.do?Cmd=7&Sid=<%=Sid%>&GJ_Id=<%=Id%>&Func_Project_Id=<%=Project_Id%>";
}

doGraphType()
</script>

</body>

</html>