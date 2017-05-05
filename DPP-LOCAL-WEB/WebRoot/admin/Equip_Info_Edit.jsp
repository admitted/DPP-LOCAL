<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>编辑项目信息</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String     Sid            	= CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus     	= (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList  Equip_Info     	= (ArrayList)session.getAttribute("Equip_Info_" + Sid);
  ArrayList  Project_Info   	= (ArrayList)session.getAttribute("Project_Info_" + Sid);
  ArrayList  DevGJ_All 				= (ArrayList)session.getAttribute("DevGJ_All_" + Sid); 

 	String PId = request.getParameter("PId"); 					//设备id
 	String TId = request.getParameter("TId"); 					//设备id
 	String Project = request.getParameter("Project");   //项目id
 	String G_Id = request.getParameter("G_Id");     		//GJ id
 	String Tel = request.getParameter("Tel");     			//设备电话
  String CName = "";
  String Project_Id = "";
	String Curr_Data = "";



	if(Equip_Info != null)
	{
		Iterator iterator = Equip_Info.iterator();
		while(iterator.hasNext())
		{
			EquipInfoBean statBean = (EquipInfoBean)iterator.next();
			if(statBean.getPId().equals(PId))
			{
					CName = statBean.getCName();
			
			}
		}
 	} 
%>
<body style="background:#CADFFF" onload="doProSelect()">
<form name="Equip_Info_Edit"  action="Admin_Equip_Info.do" method="post" target="mFrame" enctype="multipart/form-data">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/equip_info.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
				  <img src="../skin/images/mini_button_submit.gif"    style='cursor:hand;' onClick='doEdit()'>
					<img src="../skin/images/button10.gif"              style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30'>
							<td width='20%' align='center'>设备ID号</td>
							<td width='30%' align='left'>
								<%=PId%>
							</td>
							<td width='20%' align='center'>设备名称</td>
							<td width='30%' align='left'>
								<input type='text' name='CName' style='width:96%;height:20px;' value='<%=CName%>' maxlength='20'>
							</td>
						</tr>

						<tr height='30'>
							<td width='20%' align='center'>所属项目</td>
							<td width='30%' align='left'>
								<select id="Project_Id" name="Project_Id" style="width:97%;height:20px" onChange="doProSelect()"> 									  
									<option value="8888" <%=Project_Id.equals("8888")?"selected":""%> >请选择项目</option>
								<%	
 	                if(Project_Info != null){

		  								Iterator iterator = Project_Info.iterator();
											while(iterator.hasNext()){
											ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
											String Pro_Id = statBean.getId();
											String Pro_Name = statBean.getCName();				
							%>
								    <option value="<%=Pro_Id%>" <%=Project.equals(Pro_Id)?"selected":""%> > <%=Pro_Name%></option>
							<%
		    						 }

									}
							%>
								</select>
							</td>
							<td width='20%' align='center'>设备号码</td>
							<td width='30%' align='left'>
								<input type='text' name='Tel' style='width:96%;height:20px;' value='<%=Tel%>' maxlength='11'>
							</td>
						</tr>	
						<tr height='30'>
							<td width='20%' align='center'>管井编码</td>
							<td width='30%' align='left'>
								<select id="GJ_Select" style="width:97%;height:20px" >
									 						
								</select>
							</td>
						</tr>	
							
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="PId" type="hidden" value="<%=PId%>">
<input name="Sid" type="hidden" value="<%=Sid%>">
<input name="A_Pro_Id" type="hidden" value="<%=Sid%>">
</form>
</body>


<SCRIPT LANGUAGE=javascript>

if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>


function doEdit()
{
  if(confirm("信息无误,确定编辑?"))
  {
  	location = "Admin_Equip_Info.do?Cmd=40&PId=<%=PId%>&TId=<%=TId%>&Sid=<%=Sid%>&CName="
  	         + Equip_Info_Edit.CName.value
  	         + "&Pre_Id=<%=G_Id%>"
  	         + "&Pre_Project_Id=<%=Project%>"
  	         + "&Tel="+Equip_Info_Edit.Tel.value
  	         + "&After_Id=" + Equip_Info_Edit.GJ_Select.value
  	         + "&After_Project_Id=" + Equip_Info_Edit.Project_Id.value;
  }
}

function doNO()
{
	location = "Equip_Info.jsp?Sid=<%=Sid%>";
}

function doProSelect()
{
	
	//先删除
	var pid = document.getElementById('Project_Id').value;
	var length = document.getElementById('GJ_Select').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('GJ_Select').remove(0);
	}
	//再添加
		<%
		if(null != DevGJ_All)
		{
			Iterator deviter = DevGJ_All.iterator();
			while(deviter.hasNext())
			{
				 DevGJBean devBean  = (DevGJBean)deviter.next();
				 Project_Id  = devBean.getProject_Id();
				 String Id          = devBean.getId();
		%>
				if('<%=Project_Id%>' == pid)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=Id%>';
					objOption.text  = '<%=Id%>';
					
					if('<%=Id%>' == '<%=G_Id%>')
					{
					   objOption.selected = 'selected';
				  }
					document.getElementById('GJ_Select').add(objOption);
				}
		<%
			}
		}
		%>
}


</SCRIPT>
</html>