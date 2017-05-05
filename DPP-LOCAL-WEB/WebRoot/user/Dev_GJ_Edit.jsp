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
  ArrayList  User_DevGJ_Info    = (ArrayList)session.getAttribute("User_DevGJ_Info_" + Sid); 
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
 	String Top_Height= "";
 	String Base_Height= "";
 	String Size= "";
  String In_Id = "";
  String Out_Id = "";
  String Flag = "";
  String Material = "";
  String Data_Lev ="";
  String Equip_Name = "";
  String Equip_Height = "";
  String Equip_Tel = "";
	if(User_DevGJ_Info != null)
	{
		Iterator iterator = User_DevGJ_Info.iterator();
		while(iterator.hasNext())
		{
			DevGJBean devGJBean = (DevGJBean)iterator.next();
			if(devGJBean.getId().equals(Id))
			{
				 Project_Id = devGJBean.getProject_Id();
				 In_Id = devGJBean.getIn_Id();
				 Out_Id = devGJBean.getOut_Id();	
				 Project_Name = devGJBean.getProject_Name();
			 	 Top_Height= devGJBean.getTop_Height();	
			 	 Size= devGJBean.getSize();
			 	 Base_Height= devGJBean.getBase_Height();	
			   Material = devGJBean.getMaterial();	
			   Data_Lev = devGJBean.getData_Lev();
			   Flag = devGJBean.getFlag();
			   Equip_Name = devGJBean.getEquip_Name();
			   Equip_Height = devGJBean.getEquip_Height();
			   Equip_Tel = devGJBean.getEquip_Tel();
			   if(Equip_Name == null ){ Equip_Name = "无";}
			}
		}
 	}
%>
<body style="background:#CADFFF" >
<form name="User_DevGJ_Info"  method="post" target="mFrame" enctype="multipart/form-data">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/gj_edit.gif"></div><br><br><br>
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
							<td width='20%' align='center'>顶部标高</td>
							<td width='30%' align='left'>
								<input type='text' name='Top_Height' style='width:96%;height:20px;' value='<%=Top_Height%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>底部标高</td>
							<td width='30%' align='left'>
								<input type='text' name='Base_Height' style='width:96%;height:20px;' value='<%=Base_Height%>' maxlength='6'>
							</td>
						</tr>	
						<tr height='30'>
							<td width='20%' align='center'>尺寸(m)</td>
							<td width='30%' align='left'>
								<input type='text' name='Size' style='width:96%;height:20px;' value='<%=Size%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>入管编号</td>
							<td width='30%' align='left'>
								<input type='text' name='In_Id' style='width:96%;height:20px;' value='<%=In_Id%>' maxlength='27'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>起终点</td>
							<td width='30%' align='left'>
								<select name="Flag" style="width:97%;height:20px"> 
								    <option value="0" <%=Flag.equals("0")?"selected":""%>>起点</option>
								    <option value="1" <%=Flag.equals("1")?"selected":""%>>中间点</option>
								    <option value="2" <%=Flag.equals("2")?"selected":""%>>终点</option>
								    <option value="3" <%=Flag.equals("3")?"selected":""%>>水站</option>
								</select>
							</td>
							<td width='20%' align='center'>出管编号</td>
							<td width='30%' align='left'  >
								<input type='text' name='Out_Id' style='width:96%;height:20px;' value='<%=Out_Id%>' maxlength='27'>
							</td>
						</tr>		
						<tr height='30'>
							</td>
							<td width='20%' align='center'>材料类型</td>
							<td width='30%' align='left'  >
								<input type='text' name='Material' style='width:96%;height:20px;' value='<%=Material%>' maxlength='11'>
							</td>
							<td width='20%' align='center'>数据等级</td>
							<td width='30%' align='left'>
								<select name="Data_Lev" style="width:97%;height:20px"> 
								    <option value="1" <%=Data_Lev.equals("1")?"selected":""%>>人工插值</option>
								    <option value="2" <%=Data_Lev.equals("2")?"selected":""%>>原始探测</option>
								    <option value="3" <%=Data_Lev.equals("3")?"selected":""%>>竣工图数据</option>
								    <option value="4" <%=Data_Lev.equals("4")?"selected":""%>>人工插值经过现场校验</option>
								    <option value="5" <%=Data_Lev.equals("5")?"selected":""%>>原始探测经过二次校验</option>
								    <option value="6" <%=Data_Lev.equals("6")?"selected":""%>>可疑数据</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>设备名称</td>
							<td width='30%' align='left'  >
								<input type='text' name='Equip_Name' style='width:96%;height:20px;' value='<%=Equip_Name%>' maxlength='20'>
							</td>
							<td width='20%' align='center'>设备深度</td>
							<td width='30%' align='left'  >
								<input type='text' name='Equip_Height' style='width:96%;height:20px;' value='<%=Equip_Height%>' maxlength='20'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>设备号码</td>
							<td width='30%' align='left'  >
								<input type='text' name='Equip_Tel' style='width:96%;height:20px;' value='<%=Equip_Tel%>' maxlength='11'>
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
				location = "Admin_DevGJ_Info.do?Func_Project_Id=<%=Project_Id%>&Cmd=11&Id=<%=Id%>&Sid=<%=Sid%>&Top_Height="
	  	         + User_DevGJ_Info.Top_Height.value
	  	         + "&Base_Height=" + User_DevGJ_Info.Base_Height.value
	  	         + "&Size=" + User_DevGJ_Info.Size.value
	  	         + "&In_Id=" + User_DevGJ_Info.In_Id.value
	  	         + "&Out_Id=" + User_DevGJ_Info.Out_Id.value
	  	         + "&Flag=" + User_DevGJ_Info.Flag.value
	  	         + "&Material=" + User_DevGJ_Info.Material.value
	  	         + "&Data_Lev=" + User_DevGJ_Info.Data_Lev.value	
	  	         + "&Equip_Name=" + User_DevGJ_Info.Equip_Name.value
	  	         + "&Equip_Height=" + User_DevGJ_Info.Equip_Height.value
	  	         + "&Equip_Tel=" + User_DevGJ_Info.Equip_Tel.value;
			}
		}else{
			location = "Admin_DevGJ_Info.do?Func_Project_Id=<%=Project_Id%>&Cmd=11&Id=<%=Id%>&Sid=<%=Sid%>&Top_Height="
	  	         + User_DevGJ_Info.Top_Height.value
	  	         + "&Base_Height=" + User_DevGJ_Info.Base_Height.value
	  	         + "&Size=" + User_DevGJ_Info.Size.value
	  	         + "&In_Id=" + User_DevGJ_Info.In_Id.value
	  	         + "&Out_Id=" + User_DevGJ_Info.Out_Id.value
	  	         + "&Flag=" + User_DevGJ_Info.Flag.value
	  	         + "&Material=" + User_DevGJ_Info.Material.value
	  	         + "&Data_Lev=" + User_DevGJ_Info.Data_Lev.value	
	  	         + "&Equip_Name=" + User_DevGJ_Info.Equip_Name.value
	  	         + "&Equip_Height=" + User_DevGJ_Info.Equip_Height.value
	  	         + "&Equip_Tel=" + User_DevGJ_Info.Equip_Tel.value;
		}       
  }
}

function doNO()
{
	location = "Dev_GJ.jsp?Sid=<%=Sid%>";
}

</SCRIPT>
</html>