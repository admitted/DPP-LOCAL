<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>添加项目信息</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	String       Sid            = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus   currStatus     = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList    Equip_Info     = (ArrayList)session.getAttribute("Equip_Info_" + Sid);
  ArrayList    Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
  ArrayList    DevGJ_All      = (ArrayList)session.getAttribute("DevGJ_All_" + Sid); 
  ArrayList    Data_Now			  = (ArrayList)session.getAttribute("Data_Now_" + Sid);
  
%>
<body style="background:#CADFFF">
<form name="Equip_Info_Add"  action="Admin_Equip_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/equip_info.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onclick='doAdd()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30'>
							<td width='20%' align='center'>ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
							<td width='30%' align='left'>
								<table width='98%'>
									<tr>
										<td width='50%' align='left'>
											<select id="TId" name="TId" style="width:97%;height:20px" onChange="doIdSelect()">
											<%
												ArrayList Cpm_Ids = new ArrayList();
			 	                if(Data_Now != null){
				  								Iterator iterator = Data_Now.iterator();
													while(iterator.hasNext()){
														DataNowBean statBean = (DataNowBean)iterator.next();
														String Cpm_Id = statBean.getCpm_Id();
														if(!Cpm_Ids.contains(Cpm_Id))
														{
															Cpm_Ids.add(Cpm_Id);
											%>
											   			<option value="<%=Cpm_Id%>"  > <%=Cpm_Id%></option>
											<%
														}
					    						}
												}
											%>
											</select>
										</td>
										<td width='50%' align='left'>
											<!--<input type='text' name='Id' style='width:98%;height:18px;' value='' maxlength='10' onkeyup="doCheckId(this.value)">-->
											<select id="PId" name="PId" style="width:97%;height:20px">
											
											</select>
										<td>
										<!--<td width='10%' align='left' id='ErrorMsg'>&nbsp;</td>-->
									</tr>
								</table>
							</td>
							<td width='20%' align='center'>设备名称</td>
							<td width='30%' align='left'>
								<input type='text' name='CName' style='width:96%;height:20px;' value='' maxlength='20'>							        
							</td>
						</tr>					
						<tr height='30'>
							<td width='20%' align='center'>所属项目</td>
							<td width='30%' align='left'>
								<select id="Project_Id" name="Project_Id" style="width:97%;height:20px" onChange="doProSelect()">
									 <option value="8989"  >请选择项目</option>
								<%
 	                if(Project_Info != null){
		  								Iterator iterator = Project_Info.iterator();
											while(iterator.hasNext()){
											ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
											String Pro_Id = statBean.getId();
											String Pro_Name = statBean.getCName();					
								%>
								    <option value="<%=Pro_Id%>"  > <%=Pro_Name%></option>
								<%
		    						 }
									}
								%>
								</select>
							</td>	
							<td width='20%' align='center'>设备号码</td>
							<td width='30%' align='left'>
								<input type='text' name='Tel' style='width:96%;height:20px;' value='' maxlength='11'>	
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
<input name="Cmd"   type="hidden" value="10">
<input name="Sid"   type="hidden" value="<%=Sid%>">
<input name="G_Id"  type="hidden" value="">
</form>
</body>

<SCRIPT LANGUAGE=javascript>
var Flag = 0;
//自定义帐号检测
function doCheckId(Id)
{
	if(Id.Trim().length == 0)
	{
		Flag = 0;
		document.getElementById("ErrorMsg").innerText = " ";
		return;
	}
	if(Id.Trim().length > 0 && Id.Trim().length < 2)
	{
		 document.getElementById("ErrorMsg").style.color="red";
		 document.getElementById("ErrorMsg").innerText = "X";
		 Flag = 0;
		 return;
	}
	//Ajax登入提交
	if(window.XMLHttpRequest)
  {
			req = new XMLHttpRequest();
  }
  else if(window.ActiveXObject)
  {
			req = new ActiveXObject("Microsoft.XMLHTTP");
  }		
	//设置回调函数
	req.onreadystatechange = callbackCheckName;
	var url = "Equip_IdCheck.do?Id="+Id+"&Sid=<%=Sid%>";
	req.open("post",url,true);
	req.send(null);
	return true;
}
function callbackCheckName()
{
		var state = req.readyState;
		if(state==4)
		{
			var resp = req.responseText;			
			var str = "";
			if(resp != null && resp == '0000')
			{
				 document.getElementById("ErrorMsg").style.color="green";
				 document.getElementById("ErrorMsg").innerText = "√";
				 Flag = 1;
				 return;
			}
			else if(resp != null && resp == '3006')
			{
				 document.getElementById("ErrorMsg").style.color="red";
				 document.getElementById("ErrorMsg").innerText = "X";
				 Flag = 0;
				 return;
			}
		}
}

function doAdd()
{
	/*if(Flag == 0)
  {
  	alert("项目ID名称重复或有误，请重新输入！");
  	return;
  }*/
  if(Equip_Info_Add.CName.value.Trim().length < 1)
  {
    alert("请输入项目名称!");
    return;
  }  
  if(confirm("信息无误,确定添加?"))
  {
  	location = "Admin_Equip_Info.do?Cmd=40&Sid=<%=Sid%>"
  					 + "&TId=" + Equip_Info_Add.TId.value
  					 + "&PId=" + Equip_Info_Add.PId.value
  	         + "&CName=" + Equip_Info_Add.CName.value  	  
  	         + "&Tel=" + Equip_Info_Add.Tel.value         
  	         + "&After_Id=" + Equip_Info_Add.GJ_Select.value
  	         + "&After_Project_Id=" + Equip_Info_Add.Project_Id.value;
  }
}

function doNO()
{
	location = "Equip_Info.jsp?Sid=<%=Sid%>";
}

function doIdSelect()
{
	//先删除
	var pid = document.getElementById('TId').value;
	var length = document.getElementById('PId').length;
	for(var i = 0; i < length; i++)
	{
		document.getElementById('PId').remove(0);
	}
	//再添加
		<%
		if(null != Data_Now)
		{
			Iterator deviter = Data_Now.iterator();
			while(deviter.hasNext())
			{
				DataNowBean devBean  	= (DataNowBean)deviter.next();
				String Cpm_Id		  		= devBean.getCpm_Id();
				String Id          		= devBean.getId();
				//System.out.print(Project_Id + "," +Id);
		%>
				if('<%=Cpm_Id%>' == pid)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=Id%>';
					objOption.text  = '<%=Id%>';
					document.getElementById('PId').add(objOption);
				}
		<%
			}
		}
		%>
}
doIdSelect();

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
				String Project_Id  = devBean.getProject_Id();
				String Id          = devBean.getId();
				//System.out.print(Project_Id + "," +Id);
		%>
				if('<%=Project_Id%>' == pid)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=Id%>';
					objOption.text  = '<%=Id%>';
					document.getElementById('GJ_Select').add(objOption);
				}
		<%
			}
		}
		%>
}
</SCRIPT>
</html>