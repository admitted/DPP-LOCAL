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
	
	String Sid                  = CommUtil.StrToGB2312(request.getParameter("Sid"));				
  CurrStatus currStatus       = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList  Admin_DevGX_Info = (ArrayList)session.getAttribute("Admin_DevGX_Info_" + Sid); 
  ArrayList  Project_Info     = (ArrayList)session.getAttribute("Project_Info_" + Sid); 
  int sn = 0;  
  
%>
<body style=" background:#CADFFF">
<form name="Admin_DevGX_Info"  action="Admin_DevGX_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				管线类型:												
				<select  name='Func_Sub_Type_Id' style='width:100px;height:21px' onChange="doSelect()" >										
					  <option value=""    <%=currStatus.getFunc_Sub_Type_Id().equals("")?"selected":""%>        >所有管列表</option>				
					  <option value="YG"  <%=currStatus.getFunc_Sub_Type_Id().equals("YG")?"selected":""%>      >雨水管列表</option>
					  <option value="WG"  <%=currStatus.getFunc_Sub_Type_Id().equals("WG")?"selected":""%>      >污水管列表</option>
				</select>
				
				所属项目:
				<select  name='Func_Project_Id' style='width:100px;height:21px' onChange="doSelect()" >										
								
						<%
							if(null != Project_Info)
						  {
								  Iterator iterator = Project_Info.iterator();
									while(iterator.hasNext())
									{
										 ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
										 if(!"1000".equals(statBean.getId())){
										 
						%>
						<option value='<%=statBean.getId()%>' <%=currStatus.getFunc_Project_Id().equals(statBean.getId())?"selected":""%>><%=statBean.getCName()%></option>
						<%
								     }
									}
						  }
						%>
				</select>
				</td>
			<td width='20%' align='right'>		
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"         onClick='doExport()' >
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
						<td width='13%'  align='center' ><strong>终端管井</strong></td>
						<td width='6%'  align='center' ><strong>起端底标高</strong></td>
						<td width='6%'  align='center' ><strong>终端底标高</strong></td>
						<td width='5%'  align='center' ><strong>材料类型</strong></td>
						<td width='5%'  align='center' ><strong>埋设年份</strong></td>
						<td width='10%'  align='center' ><strong>数据等级</strong></td>
						<td width='10%'  align='center' ><strong>所属项目</strong></td>
						<td width='10%'  align='center' ><strong>设备名称</strong></td>
					</tr>
		<%
					if(null != Admin_DevGX_Info)
					{
						Iterator deviter = Admin_DevGX_Info.iterator();
						while(deviter.hasNext())
						{
						  sn++;
							DevGXBean dBean = (DevGXBean)deviter.next();
							String Project_Name ="";
			
							String Equip_Name = dBean.getEquip_Name();
							if(Equip_Name == null ){Equip_Name = "无";}
							String Id = dBean.getId();
							
							String Data_Lev ="";
							try{
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
								  		Data_Lev ="数据有误，需要更改！";
								  		break;
							  	}
							  }
						  }catch(Exception e){
						  	Data_Lev ="数据有误，需要更改！";
						  }finally{
						  	if(Data_Lev == null)
						  	{
						  		Data_Lev ="";
						  	}
						  }
					%>   		    	
					<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td  align=center style="cursor:hand " onmouseout="this.style.color='#000000';" onmouseover="this.style.color='#FF0000';"  title="点击查看" onClick="doEdit('<%=Id%>')"><U><%=Id%>&nbsp; </U></td>
						<td <%=((dBean.getDiameter()).equals("0")?"style='background:yellow'":"")%>><%= dBean.getDiameter()%> &nbsp; </td>
						<td <%=((dBean.getLength()).equals("0")?"style='background:yellow'":"")%>><%= dBean.getLength()%> &nbsp; </td>
						<td><%= dBean.getStart_Id()%>&nbsp;  </td>
						<td><%= dBean.getEnd_Id()%> &nbsp; </td>
						<td <%=((dBean.getStart_Height()).equals("0")?"style='background:yellow'":"")%>><%= dBean.getStart_Height()%>&nbsp;</td>
						<td <%=((dBean.getEnd_Height()).equals("0")?"style='background:yellow'":"")%>><%= dBean.getEnd_Height()%>&nbsp;</td>
						<td <%=((dBean.getMaterial()).equals("")?"style='background:yellow'":"")%>><%= dBean.getMaterial()%> &nbsp; </td>
						<td <%=((dBean.getBuried_Year()).equals("")?"style='background:yellow'":"")%>><%= dBean.getBuried_Year()%>&nbsp;</td>
						<td <%=(Data_Lev.equals("")?"style='background:yellow'":"")%>><%= Data_Lev%>&nbsp;</td>	
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
				      	 <td nowrap><%=currStatus.GetPageHtml("Admin_DevGX_Info")%></td>
				    	</tr>			    		
					 </table>
				</td>
		  </tr>					
										
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
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
function doSelect()
{
	Admin_DevGX_Info.submit();
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
	Admin_DevGX_Info.CurrPage.value = pPage;
	Admin_DevGX_Info.submit();
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
		var url = "Admin_File_GX_Export.do?Sid=<%=Sid%>&Func_Project_Id="+Admin_DevGX_Info.Func_Project_Id.value+"&Func_Sub_Type_Id="+Admin_DevGX_Info.Func_Sub_Type_Id.value;
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
	location = "Admin_DevGX_Info.do?Cmd=5&Sid=<%=Sid%>&Id="+pId+"&Func_Project_Id="+Admin_DevGX_Info.Func_Project_Id.value;
}

</SCRIPT>
</html>