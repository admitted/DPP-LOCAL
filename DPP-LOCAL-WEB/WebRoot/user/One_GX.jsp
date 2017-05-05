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
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));			
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  DevGXBean  One_GX        = (DevGXBean)session.getAttribute("One_GX_" + Sid); 
  
  String TId 				= One_GX.getId();
  String Diameter 	= One_GX.getDiameter();
  String Length 		= One_GX.getLength();
	String Material		= One_GX.getMaterial();
  String Curr_Data	= One_GX.getCurr_Data();
%>
<body style=" background:#CADFFF">
<form name="Dev_GX"  action="doGx_Select.do" method="post" target="mFrame">
<div>
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">	    	
		<tr  height='25'>
				<td width="35px" align='center' >编码</td>
				<td>&nbsp;<%=TId%>&nbsp; </td>
		</tr>
		<tr height='25'>
				<td width="35px" align='center' >直径</td>
				<td>&nbsp;<%=Diameter%>&nbsp;</td>
		</tr>
		<tr height='25'>
				<td width="35px" align='center' >长度</td>
				<td>&nbsp;<%=Length%> &nbsp; </td>
		</tr>					
		<tr height='25'>
				<td  width="35px" align='center'>材料</td>
				<td>&nbsp;<%=Material%> &nbsp; </td>
		</tr>
		<tr height='25'>
				<td width="35px" align='center' >流量</td>
				<td>&nbsp;<%=Curr_Data%></td>
		</tr>
</table>		
</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>


</SCRIPT>
</html>