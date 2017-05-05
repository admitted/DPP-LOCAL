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
	String Sid                     = CommUtil.StrToGB2312(request.getParameter("Sid"));				
  CurrStatus currStatus          = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList  User_DevGX_Info     = (ArrayList)session.getAttribute("User_DevGX_Info_" + Sid);  
  UserInfoBean UserInfo          = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  ArrayList User_Fp_Role         = (ArrayList)session.getAttribute("User_Fp_Role_" + Sid); 
  
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
  
  String Project_Id ="";
  if(null != currStatus){
  	Project_Id = currStatus.getFunc_Project_Id();
  }
  
  int sn = 0;  
%>
<body style=" background:#CADFFF">
<form name="User_DevGX_Info"  action="User_DevGX_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				&nbsp;管线类型:												
				<select  name='Func_Sub_Type_Id' style='width:100px;height:21px' onChange="doSelect()" >										
					  <option value=""    <%=currStatus.getFunc_Sub_Type_Id().equals("999")?"selected":""%>     >所有管列表</option>				
					  <option value="YG"  <%=currStatus.getFunc_Sub_Type_Id().equals("YG")?"selected":""%>      >雨水管列表</option>
					  <option value="WG"  <%=currStatus.getFunc_Sub_Type_Id().equals("WG")?"selected":""%>      >污水管列表</option>
					  <option value="HG"  <%=currStatus.getFunc_Sub_Type_Id().equals("HG")?"selected":""%>      >合流管列表</option>
				</select>
				&nbsp;排序类型:												
				<select  name='Func_Sort_Id' style='width:100px;height:21px' onChange="doSelect()" >										
					  <option value="01"  <%=currStatus.getFunc_Sort_Id().equals("01")?"selected":""%>   >按序号列表</option>				
					  <option value="02"  <%=currStatus.getFunc_Sort_Id().equals("02")?"selected":""%>   >按管径列表</option>
					  <option value="03"  <%=currStatus.getFunc_Sort_Id().equals("03")?"selected":""%>   >按材料列表</option>
				</select>
				
				</td>
			<td width='20%' align='right'>		
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0303' ctype='1'/>; cursor:hand" src="../skin/images/excel.gif" onClick='doExport()' >
			</td>
		</tr>		
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='30'>
						<td width='10%'  align='center' ><strong>编    码</strong></td>
						<td width='6%'  align='center' ><strong>直    径</strong></td>
						<td width='6%'  align='center' ><strong>长    度</strong></td>
						<td width='13%'  align='center' ><strong>起端管井</strong></td>
						<td width='13%'  align='center' ><strong>结端管井</strong></td>
						<td width='6%'  align='center' ><strong>起端底标高</strong></td>
						<td width='6%'  align='center' ><strong>终端底标高</strong></td>
						<td width='5%'  align='center' ><strong>材料类型</strong></td>
						<td width='5%'  align='center' ><strong>埋设年份</strong></td>
						<td width='10%'  align='center' ><strong>数据等级</strong></td>
						<td width='10%'  align='center' ><strong>所属项目</strong></td>
						<td width='10%'  align='center' ><strong>设备名称</strong></td>
					</tr>
		<%
					if(null != User_DevGX_Info)
					{
						Iterator deviter = User_DevGX_Info.iterator();
						while(deviter.hasNext())
						{
						  sn++;
							DevGXBean dBean = (DevGXBean)deviter.next();
							String Project_Name ="";
			
							String Equip_Name = dBean.getEquip_Name();
							if(Equip_Name == null ){Equip_Name = "无";}
							String Id = dBean.getId();
							
							String Data_Lev ="";
						  if(dBean.getData_Lev() != null && !dBean.getData_Lev().equals(""))
						  {
						  	switch(Integer.parseInt(dBean.getData_Lev()))
						  	{
						  		case 1:
						  			Data_Lev ="人工插值";
						  			break;
						  		case 2:
							  		Data_Lev ="原始探测";
							  		break;
						  		case 3:
							  		Data_Lev ="竣工图数据";
							  		break;
						  		case 4:
							  		Data_Lev ="人工插值经过现场校验";
							  		break;
						  		case 5:
							  		Data_Lev ="原始探测经过二次校验";
							  		break;
						  		case 6:
							  		Data_Lev ="可疑数据";
							  		break;
						  		default:
							  		Data_Lev ="数据库录入有误，需要更改！";
							  		break;
						  	}
						  	if(Data_Lev == null)
						  	{
						  		Data_Lev ="";
						  	}
						  }
					%>   		    	
					<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<!--<%=((dBean.getDiameter()).equals("0")?"style='background:yellow'":"")%>-->
						<td name="dev_id" align=center onClick="doEdit('<%=Id%>')"><U><%=Id%>&nbsp; </U></td>
						<td ><%= dBean.getDiameter()%> &nbsp; </td>
						<td ><%= dBean.getLength()%> &nbsp; </td>
						<td ><%= dBean.getStart_Id()%>&nbsp;  </td>
						<td ><%= dBean.getEnd_Id()%> &nbsp; </td>
						<td ><%= dBean.getStart_Height()%>&nbsp;</td>
						<td ><%= dBean.getEnd_Height()%>&nbsp;</td>
						<td ><%= dBean.getMaterial()%> &nbsp; </td>
						<td ><%= dBean.getBuried_Year()%>&nbsp;</td>
						<td ><%= Data_Lev%>&nbsp;</td>	
						<td><%= dBean.getProject_Name()%> &nbsp; </td>	
						<td><%= Equip_Name %> &nbsp; </td>
					</tr>													
					<%
						}
					}
					for(int i=0;i<(MsgBean.CONST_PAGE_SIZE - sn);i++)
					{
						if(sn % 2 != 0)
					  {
					%>				  
				      <tr <%=((i%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				      	<td>&nbsp;<td>&nbsp;<td>&nbsp;<td>&nbsp;<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>
					<%
						}
					  else
					  {
					%>				
	            <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
		            <td>&nbsp;<td>&nbsp;<td>&nbsp;<td>&nbsp;<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
		          </tr>	        
					<%
       			}
     			}
					%> 
				<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				<td colspan="13" class="table_deep_blue" >
					 <table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
				    	<tr valign="bottom">
				      	 <td nowrap><%=currStatus.GetPageHtml("User_DevGX_Info")%></td>
				    	</tr>			    		
					 </table>
				</td>
		  </tr>					
										
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="1">
<input type="hidden" name="Sid" value="<%=Sid%>">
<input type="hidden" name="Func_Project_Id" value="<%=Project_Id%>">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
	if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0302' ctype='1'/>' == '')
{
	var idarr = document.getElementsByName('dev_id');
	for(var i=0; i<idarr.length; i++)
	{
		idarr[i].attachEvent('onmouseout', function (){this.style.color='#000000'});
		idarr[i].attachEvent('onmouseover', function (){this.style.color='#FF0000'});
	}
}

function doSelect()
{
	User_DevGX_Info.submit();
}

function GoPage(pPage)
{
	if(pPage == "")
	{
		 alert("请输入目标页面的数值!");
		 return;
	}
	if(pPage < 1)
	{
	   	alert("请输入页数大于1");
		  return;	
	}
	if(pPage > <%=currStatus.getTotalPages()%>)
	{
		pPage = <%=currStatus.getTotalPages()%>;
	}
	User_DevGX_Info.CurrPage.value = pPage;
	User_DevGX_Info.submit();
}

//数据导出
var req = null;
function doExport()
{	
	if(0 == <%=sn%>)
	{
		alert('当前无记录!');
		return;
	}
	
	if(confirm("确定导出?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		req.onreadystatechange = callbackForName;
		var url = "Admin_File_GX_Export.do?Sid=<%=Sid%>&Func_Project_Id="+User_DevGX_Info.Func_Project_Id.value+"&Func_Sub_Type_Id="+User_DevGX_Info.Func_Sub_Type_Id.value;
		req.open("post",url,true);
		req.send(null);
		return true;
	}
}
function callbackForName()
{
	var state = req.readyState;
	if(state==4)
	{
		var resp = req.responseText;			
		var str = "";
		if(resp != null)
		{
			location.href = "../files/excel/" + resp + ".xls";
		}
	}
}

function doEdit(pId)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0302' ctype='1'/>' == 'none')
	{
		return;
	}
	
	var project = <%=Project_Id%>+"";
	if(project.substr(0,1) != 9)
	{
		if(confirm("这是原始数据，请慎重修改！"))
		{
			location = "Dev_GX_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
		}
	}else{
		location = "Dev_GX_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
	}
}

</SCRIPT>
</html>