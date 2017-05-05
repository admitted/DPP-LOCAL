<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
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
  ArrayList User_Fp_Role    = (ArrayList)session.getAttribute("User_Fp_Role_" + Sid);
  UserInfoBean UserInfo     = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
   
  //功能权限
	String FpId = "";
  if(null != UserInfo)
  {
		FpId = UserInfo.getFp_Role();
	}
	String FpIdName = "";
	String FpList = "";
	if(null != FpId && FpId.length() > 0 && null != User_Fp_Role)
	{
		Iterator roleiter = User_Fp_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
				FpIdName = roleBean.getCName();
			}
		}
	}
  
	
%>
<body  style=" background:#CADFFF">

<div id="cap"><img src="../skin/images/gx_record.gif"></div><br><br><br>

	<div id="right_table_center" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0401' ctype='1'/>">
		<font size=3 color=red>注：先完全导入管井数据，再进行管段数据的导入！</font><br><br>
		<table>
			<tr>
				<td>
				  <form name="Admin_Import_GJ" action="Admin_Import_GJ.do" method="post" target="mFrame" enctype="multipart/form-data">
					<table width="80%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
						<tr height='40'>			
							<td align='middle'>
								<b>管井数据录入</b>
							</td>
							<td width='20' align='middle' >
								<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGJ_Import()'>
						  </td>
						</tr>	
						<tr height='40' valign='middle'>
							<td width="30%" align='middle' colspan=2>
									所属项目:												
										<%
											if(null != Project_Info)
										  {
												  Iterator iterator = Project_Info.iterator();
													while(iterator.hasNext())
													{
														 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
														 if(Project_Id.equals(statBean.getId()))
														 {
										%>
										<%=statBean.getCName()%>
										<%
												     }
													}
										  }
										%>
						  </td>
						</tr>		
						<tr height='40'>			
							<td align='middle' colspan=2>
								<input id='Import_GJ_File' name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
							</td>
						</tr>	
					</table>
					<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
					<input type="hidden" name="Sid" value="<%=Sid%>">
					</form>
				</td>
				<td>
					<form name="Admin_Import_GD" action="Admin_Import_GD.do" method="post" target="mFrame" enctype="multipart/form-data">
						<table width="80%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
							<tr height='40'>			
								<td align='middle'>
									<b>管段数据录入</b>
								</td>
								<td width='20' align='middle' >
									<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGD_Import()'>
							  </td>
							</tr>	
							<tr height='40' valign='middle'>
								<td width="30%" align='middle' colspan=2>
										所属项目:												
											<%
												if(null != Project_Info)
											  {
													  Iterator iterator = Project_Info.iterator();
														while(iterator.hasNext())
														{
															 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
															 if(Project_Id.equals(statBean.getId()))
															 {
											%>
											<%=statBean.getCName()%>
											<%
													     }
														}
											  }
											%>
							   </td>
							</tr>		
							<tr height='40'>			
								<td align='middle' colspan=2>
									<input name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
								</td>
							</tr>	
						</table>
						<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
						<input type="hidden" name="Sid" value="<%=Sid%>">
					</form>
				</td>
			</tr>
		</table>
	</div>

	<div id="right_table_center" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0402' ctype='1'/>">
		<br><br><br>
	<table>
		<tr>
			<td>
			  <form name="Admin_Update_GJ" action="Admin_Update_GJ.do" method="post" target="mFrame" enctype="multipart/form-data">
					<table width="80%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
						<tr height='40'>			
							<td align='middle'>
								<b>管井数据更新</b>
							</td>
							<td width='20' align='middle' >
								<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGJ_Update()'>
						  </td>
						</tr>	
						<tr height='40' valign='middle'>
							<td width="30%" align='middle' colspan=2>
									所属项目:												
										<%
											if(null != Project_Info)
										  {
												  Iterator iterator = Project_Info.iterator();
													while(iterator.hasNext())
													{
														 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
														 if(Project_Id.equals(statBean.getId()))
														 {
										%>
										<%=statBean.getCName()%>
										<%
												     }
													}
										  }
										%>
						   </td>
						</tr>		
						<tr height='40'>			
							<td align='middle' colspan=2>
								<input name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
							</td>
					  </tr>	
					</table>
					<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
					<input type="hidden" name="Sid" value="<%=Sid%>">
				</form>
			
			</td>
			<td>
			
				<form name="Admin_Update_GD" action="Admin_Update_GD.do" method="post" target="mFrame" enctype="multipart/form-data">
					<table width="80%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0>
						<tr height='40'>			
							<td align='middle'>
								<b>管段数据更新</b>
							</td>
							<td width='20' align='middle' >
								<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doGD_Update()'>
						  </td>
						</tr>	
						<tr height='40' valign='middle'>
							<td width="30%" align='middle' colspan=2>
									所属项目:												
										<%
											if(null != Project_Info)
										  {
												  Iterator iterator = Project_Info.iterator();
													while(iterator.hasNext())
													{
														 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
														 if(Project_Id.equals(statBean.getId()))
														 {
										%>
										<%=statBean.getCName()%>
										<%
												     }
													}
										  }
										%>
						   </td>
					  </tr>		
					  <tr height='40'>			
							<td align='middle' colspan=2>
								<input name='file' type='file' style='width:250px;height:20px;' title='数据导入'>
							</td>
					  </tr>	
					</table>
					<input type="hidden" name="Project_Id" value="<%=Project_Id%>">
					<input type="hidden" name="Sid" value="<%=Sid%>">
				</form>
			</td>
		</tr>
	</table>
</div>

</body>
<script LANGUAGE="javascript">
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

//授权密码
function rightPWD()
{
	var input = prompt("请输入授权密码:");
	//取消
	if(input == null)
	{
		history.go(-1)
		return;
	}
	//确认
	if(input != "111111")
	{
		alert("授权码错误！");
		rightPWD();
	}
	return;
}
rightPWD();

//管井数据导入
function doGJ_Import()
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
  	var project = <%=Project_Id%>+"";
		if(project.substr(0,1) != 9)
		{
			if(confirm("这是原始数据，确认提交？"))
			{
				Admin_Import_GJ.submit();
			}
		}else{
			Admin_Import_GJ.submit();
		}
		//Admin_Import_GJ.submit();
  }
}

//管段数据导入
function doGD_Import()
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
  	var project = <%=Project_Id%>+"";
		if(project.substr(0,1) != 9)
		{
			if(confirm("这是原始数据，确认提交？"))
			{
				Admin_Import_GD.submit();
			}
		}else{
			Admin_Import_GD.submit();
		}
  	//Admin_Import_GD.submit();
	}	
}

//管井数据更新
function doGJ_Update()
{	
	if(Admin_Update_GJ.file.value.Trim().length > 0)
  {
  	if(Admin_Update_GJ.file.value.indexOf('.xls') == -1 
  	&& Admin_Update_GJ.file.value.indexOf('.XLS') == -1 
  	&& Admin_Update_GJ.file.value.indexOf('.xlsx') == -1 
  	&& Admin_Update_GJ.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}
  }								
	if(confirm('信息无误,确定提交?'))
  {
  	var project = <%=Project_Id%>+"";
		if(project.substr(0,1) != 9)
		{
			if(confirm("这是原始数据，确认提交？"))
			{
				Admin_Update_GJ.submit();
			}
		}else{
			Admin_Update_GJ.submit();
		}
  	//Admin_Update_GJ.submit();
  }	
}

//管段数据更新
function doGD_Update()
{	
	if(Admin_Update_GD.file.value.Trim().length > 0)
  {
  	if(Admin_Update_GD.file.value.indexOf('.xls') == -1 
  	&& Admin_Update_GD.file.value.indexOf('.XLS') == -1 
  	&& Admin_Update_GD.file.value.indexOf('.xlsx') == -1 
  	&& Admin_Update_GD.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}
  }								
	if(confirm('信息无误,确定提交?'))
  {
  	var project = <%=Project_Id%>+"";
		if(project.substr(0,1) != 9)
		{
			if(confirm("这是原始数据，确认提交？"))
			{
				Admin_Update_GD.submit();
			}
		}else{
			Admin_Update_GD.submit();
		}
  	//Admin_Update_GD.submit();
	}	
}
</script>
</html>