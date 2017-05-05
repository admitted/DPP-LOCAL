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
<title>管线查询</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	String     Sid 						= CommUtil.StrToGB2312(request.getParameter("Sid"));			
  CurrStatus currStatus     = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String 		 Project_Id     = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
%>
<body style=" background:#CADFFF">
	<form name="Analog_rainfall" action="Analog_rainfall.do" method="post" enctype="multipart/form-data">
		<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">	    	
			<tr  height='25'>
					<td width="35px" align='center' >导入数据</td>
			</tr>
			<tr>
					<td><input name='file' type='file' style='width:250px;height:20px;' title='数据导入'></td>
			</tr>
			<tr>
				<td>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAnalog_Import()'>
				</td>
			</tr>
		</table>
		<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
		<input type="hidden" name="Sid" value="<%=Sid%>">
	</form>		
</body>
<script LANGUAGE="javascript">
	
function doAnalog_Import()
{	
	if(Analog_rainfall.file.value.Trim().length > 0)
  {
  	if(Analog_rainfall.file.value.indexOf('.xls') == -1 
  	&& Analog_rainfall.file.value.indexOf('.XLS') == -1 
  	&& Analog_rainfall.file.value.indexOf('.xlsx') == -1 
  	&& Analog_rainfall.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}else if(confirm('信息无误,确定提交?'))
	  {
				Analog_rainfall.submit();
			//Admin_Import_GJ.submit();
	  }
	}
}

</SCRIPT>
</html>