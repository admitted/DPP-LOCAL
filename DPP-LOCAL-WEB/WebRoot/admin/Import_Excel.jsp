<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
</head>
<%
	
	String Sid                = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Project_Id         = CommUtil.StrToGB2312(request.getParameter("Project_Id"));
	
  CurrStatus currStatus     = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList  Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
  
	
%>
<body  style=" background:#CADFFF">

<div id="cap"><img src="../skin/images/gx_record.gif"></div><br><br><br><br>
<div id="right_table_center">
	
	<font size=5 color=red>注：先完全导入管井数据，再进行管段数据的导入！</font>
	<br><br><br>
  <form name="Admin_Import_GJ" action="Admin_Import_GJ.do" method="post" target="mFrame" enctype="multipart/form-data">
	<table width="60%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
		<tr height='40'>			
			<td align='middle'>
				<b>管井数据录入</b>
			</td>
			<td width='20' align='middle' >
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGJ_Submit()'>
		  </td>
		</tr>	
		<tr height='40' valign='middle'>
			<td width="30%" align='middle' colspan=2>
					所属项目:
				<select name='Project_Id' style='width:100px;height:21px'>												
						<%
							if(null != Project_Info)
						  {
								  Iterator iterator = Project_Info.iterator();
									while(iterator.hasNext())
									{
										 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
										 if(!"1000".equals(statBean.getId())){
						%>
						<option value='<%=statBean.getId()%>' <%=Project_Id.equals(statBean.getId())?"selected":""%>><%=statBean.getCName()%></option>
						<%
								     }
									}
						  }
						%>
				</select>
		   </td>
		  </tr>		
		  <tr height='40'>			
				<td align='middle' colspan=2>
					<input name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
				</td>
		  </tr>	
	</table>
	<input type="hidden" name="Sid" value="<%=Sid%>">
	</form>
	
	<br><br><br>
	
	<form name="Admin_Import_GD" action="Admin_Import_GD.do" method="post" target="mFrame" enctype="multipart/form-data">
	<table width="60%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
		<tr height='40'>			
			<td align='middle'>
				<b>管段数据录入</b>
			</td>
			<td width='20' align='middle' >
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGD_Submit()'>
		  </td>
		</tr>	
		<tr height='40' valign='middle'>
			<td width="30%" align='middle' colspan=2>
					所属项目:
				<select name='Project_Id' style='width:100px;height:21px'>												
						<%
							if(null != Project_Info)
						  {
								  Iterator iterator = Project_Info.iterator();
									while(iterator.hasNext())
									{
										 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
										 if(!"1000".equals(statBean.getId())){
						%>
						<option value='<%=statBean.getId()%>' <%=Project_Id.equals(statBean.getId())?"selected":""%>><%=statBean.getCName()%></option>
						<%
								     }
									}
						  }
						%>
				</select>
		   </td>
		  </tr>		
		  <tr height='40'>			
				<td align='middle' colspan=2>
					<input name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
				</td>
		  </tr>	
	</table>
	<input type="hidden" name="Sid" value="<%=Sid%>">
	</form>
</div>
</body>
<script LANGUAGE="javascript">
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>
	

function doGJ_Submit()
{	
	if(Admin_Import_GJ.file.value.Trim().length > 0)
  {
  	if(Admin_Import_GJ.file.value.indexOf('.xls') == -1 
  	&& Admin_Import_GJ.file.value.indexOf('.XLS') == -1 
  	&& Admin_Import_GJ.file.value.indexOf('.xlsx') == -1 
  	&& Admin_Import_GJ.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}
  }								
	if(confirm('信息无误,确定提交?'))
  {
		Admin_Import_GJ.submit();
  }	
}

function doGD_Submit()
{	
	if(Admin_Import_GD.file.value.Trim().length > 0)
  {
  	if(Admin_Import_GD.file.value.indexOf('.xls') == -1 
  	&& Admin_Import_GD.file.value.indexOf('.XLS') == -1 
  	&& Admin_Import_GD.file.value.indexOf('.xlsx') == -1 
  	&& Admin_Import_GD.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}
  }								
	if(confirm('信息无误,确定提交?'))
  {
		Admin_Import_GD.submit();
  }	
}
</script>
</html>