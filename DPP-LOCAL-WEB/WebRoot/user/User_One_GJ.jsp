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
<title>����ܾ���Ϣ��ʾ</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  DevGJBean  One_GJ        = (DevGJBean)session.getAttribute("User_DevGJ_Info_" + Sid); 

	String Project_Id   = "";
  String TId 					= "";
  String Top_Height 	= "";
  String Base_Height 	= "";
	String Material			= "";
  String Curr_Data		= "";
	if(null != One_GJ)
	{
		Project_Id    = One_GJ.getProject_Id();
		TId 					= One_GJ.getId();
		Top_Height 		= One_GJ.getTop_Height();
		Base_Height 	= One_GJ.getBase_Height();
		Material			= One_GJ.getMaterial();
		Curr_Data			= One_GJ.getCurr_Data();
	}

%>
<body style=" background:#CADFFF">
<div>
	<form name=""  action="" method="post" >
		<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					    	
			<tr height='25'>
				<td width="35px" align='center' >����</td>
				<td >&nbsp;<%=TId%>&nbsp; </td>
		  </tr>
			<tr height='25'>
				<td width="35px" align='center' >����</td>
				<td >&nbsp;<%=Top_Height%></td>
			</tr>
			<tr height='25'>
				<td width="35px"  align='center' >�׸�</td>
				<td >&nbsp;<%=Base_Height%>&nbsp;</td>
			</tr>
		  <tr height='25'>
				<td width="35px" align='center' >����</td>
				<td >&nbsp;<%=Material%> &nbsp;</td>
		  </tr>
		  <tr height='25'>
				<td width="35px" align='center' >ˮλ</td>
				<td >&nbsp;<%=Curr_Data%> &nbsp; </td>
		  </tr>									
			
			<tr height='30'>
					<td colspan='2' align='center'>
						<a href='#' onClick="doDel('<%=TId%>')"><font color='red'>ȡ����ע</font></a>
					</td>	
			</tr>							
		</table>	
	</form>
</div>

<input type="button" id="_ButtonOK_0" style="display:none;">
</body>
<SCRIPT LANGUAGE=javascript>
var reqDel = null;
function doDel(pId)
{
	if(confirm('ȷ��ɾ����ǰվ���ע?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqDel = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDel = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqDel.onreadystatechange = function()
		{
		  var state = reqDel.readyState;
		  if(state == 4)
		  {
		    if(reqDel.status == 200)
		    {
		      var Resp = reqDel.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')  //��⵽������,ִ�д��ڹر�
		      {		     	
		      	alert('ɾ����ע�ɹ�!��ˢ�µ�ͼ!');		
		      	window.top.frames.mFrame.document.getElementById('DelFlag').value = 1;
		    		return;
		      }  
		      else
		      {
		      	alert('ɾ����עʧ��!');
		    		return;
		      }   
		    }
		    else
		    {
		    	alert('ɾ����עʧ��!');
		    	return;
		    }
		  }
		};
		var url = "Admin_Drag_GJ.do?Cmd=16&Sid=<%=Sid%>&Project_Id=<%=Project_Id%>&Id="+pId+"&currtime="+new Date();
		reqDel.open("POST",url,true);
		reqDel.send(null);
		return true;
	}
}

</SCRIPT>
</html>