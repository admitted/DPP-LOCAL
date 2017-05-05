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
	
	String     Sid                = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus         = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList  User_DevGX_Info    = (ArrayList)session.getAttribute("User_DevGX_Info_" + Sid); 
  UserInfoBean UserInfo         = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  ArrayList User_Fp_Role        = (ArrayList)session.getAttribute("User_Fp_Role_" + Sid);
  
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
  
 	 String Id = request.getParameter("Id"); 
 	 String Project_Id = "";
 	 String Project_Name = ""; 
	 String Diameter = "";
	 String Length = "";
	 String Start_Id = "";
	 String End_Id = "";
	 String Start_Height = "";
	 String End_Height = "";
	 String Material = "";
	 String Buried_Year = "";
	 String Data_Lev ="";
	 String Equip_Name = "";
	 
	if(User_DevGX_Info != null)
	{
		Iterator iterator = User_DevGX_Info.iterator();
		while(iterator.hasNext())
		{
			DevGXBean devGXBean = (DevGXBean)iterator.next();
			if(devGXBean.getId().equals(Id))
			{
			Id = devGXBean.getId();
			Project_Id = devGXBean.getProject_Id();
			Project_Name = devGXBean.getProject_Name();
			Diameter = devGXBean.getDiameter();	
			Length= devGXBean.getLength();	
			Start_Id= devGXBean.getStart_Id();	
			End_Id = devGXBean.getEnd_Id();
			Start_Height = devGXBean.getStart_Height();
			End_Height = devGXBean.getEnd_Height();
			Material = devGXBean.getMaterial();
			Buried_Year = 	devGXBean.getBuried_Year();
			Equip_Name = devGXBean.getEquip_Name();
			Data_Lev = devGXBean.getData_Lev();
			if(Equip_Name == null ){ Equip_Name = "无";}
			}
		}
  } 
%>
<body style="background:#CADFFF" >
<form name="Dev_GX_Edit"  method="post" target="mFrame" enctype="multipart/form-data">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/gx_edit.gif"></div><br><br><br>
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
							<td width='20%' align='center'>管井编码</td>
							<td width='30%' align='left'>
								<%=Id%>
							</td>
							<td width='20%' align='center'>所属项目</td>
							<td width='30%' align='left'>
								 <%=Project_Name%>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>直径</td>
							<td width='30%' align='left'>
								<input type='text' name='Diameter' style='width:96%;height:20px;' value='<%=Diameter%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>长度</td>
							<td width='30%' align='left'>
								<input type='text' name='Length' style='width:96%;height:20px;' value='<%=Length%>' maxlength='6'>
							</td>
						</tr>	
						<tr height='30'>
							<td width='20%' align='center'>起端底标高</td>
							<td width='30%' align='left'>
								<input type='text' name='Start_Height' style='width:96%;height:20px;' value='<%=Start_Height%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>起端管井</td>
							<td width='30%' align='left'>
								<input type='text' name='Start_Id' style='width:96%;height:20px;' value='<%=Start_Id%>' maxlength='27'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>终端底标高</td>
							<td width='30%' align='left'>
								<input type='text' name='End_Height' style='width:96%;height:20px;' value='<%=End_Height%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>终端管井</td>
							<td width='30%' align='left'>
								<input type='text' name='End_Id' style='width:96%;height:20px;' value='<%=End_Id%>' maxlength='27'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>材料类型</td>
							<td width='30%' align='left'  >
								<input type='text' name='Material' style='width:96%;height:20px;' value='<%=Material%>' maxlength='11'>
							</td>
							<td width='20%' align='center'>埋设年份</td>
							<td width='30%' align='left'  >
								<input type='text' name='Buried_Year' style='width:96%;height:20px;' value='<%=Buried_Year%>' maxlength='11'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>数据等级</td>
							<td width='30%' align='left'  >
								<select name="Data_Lev" style="width:97%;height:20px"> 					
								    <option value="1" <%=Data_Lev.equals("1")?"selected":""%>>人工插值</option>
								    <option value="2" <%=Data_Lev.equals("2")?"selected":""%>>原始探测</option>
								    <option value="3" <%=Data_Lev.equals("3")?"selected":""%>>竣工图数据</option>
								    <option value="4" <%=Data_Lev.equals("4")?"selected":""%>>人工插值经过现场校验</option>
								    <option value="5" <%=Data_Lev.equals("5")?"selected":""%>>原始探测经过二次校验</option>
								    <option value="6" <%=Data_Lev.equals("6")?"selected":""%>>可疑数据</option>
								</select>
							</td>
							<td width='20%' align='center'>设备名称</td>
							<td width='30%' align='left'  >
								<%=Equip_Name%>
							</td>
						</tr>			
							
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Id" type="hidden" value="<%=Id%>">
<input name="Sid" type="hidden" value="<%=Sid%>">

</form>
</body>


<SCRIPT LANGUAGE=javascript>

function doEdit()
{
  if(confirm("信息无误,确定编辑?"))
  {
  	var project = <%=Project_Id%>+"";
		if(project.substr(0,1) != 9)
		{
			if(confirm("这是原始数据，请慎重修改！"))
			{
				location = "Admin_DevGX_Info.do?Func_Project_Id=<%=Project_Id%>&Cmd=11&Id=<%=Id%>&Sid=<%=Sid%>&Diameter="
  	         + Dev_GX_Edit.Diameter.value
  	         + "&Length=" + Dev_GX_Edit.Length.value
  	         + "&Start_Id=" + Dev_GX_Edit.Start_Id.value
  	         + "&End_Id=" + Dev_GX_Edit.End_Id.value
  	         + "&Start_Height=" + Dev_GX_Edit.Start_Height.value
  	         + "&End_Height=" + Dev_GX_Edit.End_Height.value
  	         + "&Material=" + Dev_GX_Edit.Material.value
  	         + "&Buried_Year=" + Dev_GX_Edit.Buried_Year.value
  	         + "&Data_Lev=" + Dev_GX_Edit.Data_Lev.value
			}
		}else{
			location = "Admin_DevGX_Info.do?Func_Project_Id=<%=Project_Id%>&Cmd=11&Id=<%=Id%>&Sid=<%=Sid%>&Diameter="
  	         + Dev_GX_Edit.Diameter.value
  	         + "&Length=" + Dev_GX_Edit.Length.value
  	         + "&Start_Id=" + Dev_GX_Edit.Start_Id.value
  	         + "&End_Id=" + Dev_GX_Edit.End_Id.value
  	         + "&Start_Height=" + Dev_GX_Edit.Start_Height.value
  	         + "&End_Height=" + Dev_GX_Edit.End_Height.value
  	         + "&Material=" + Dev_GX_Edit.Material.value
  	         + "&Buried_Year=" + Dev_GX_Edit.Buried_Year.value
  	         + "&Data_Lev=" + Dev_GX_Edit.Data_Lev.value
		}  
  }
}

function doNO()
{
	location = "Dev_GX.jsp?Sid=<%=Sid%>";
}

</SCRIPT>
</html>