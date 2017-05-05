<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>项目信息</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String       Sid              = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus   currStatus       = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList    Equip_Info       = (ArrayList)session.getAttribute("Equip_Info_" + Sid);
	String       BDate            = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
  int sn = 0;
  
%>
<body style="background:#CADFFF">
<form name="Equip_Info"  action="Admin_Equip_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/equip_info.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="80%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			
			<tr height='30'>
				<td colspan="2" width='70%' align='right'>
					<img src="../skin/images/mini_button_add.gif" style='cursor:hand;' onClick='doAdd()'>
				</td>
			</tr>
			
			
			<tr height='30'>
				<td width='100%' align='center' colspan=2>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr>
							<td width="8%"  class="table_deep_blue">序号</td>
							<td width="10%"  class="table_deep_blue">设备ID</td>
							<td width="10%" class="table_deep_blue">设备名称</td>
							<td width="10%" class="table_deep_blue">设备号码</td>
							<td width="20%" class="table_deep_blue">项目名称</td>
							<td width="10%" class="table_deep_blue">编码</td>
							<td width="13%" class="table_deep_blue">最后上传时间</td>
							<td width="10%" class="table_deep_blue">最后上传数据</td>
							<td width="10%" class="table_deep_blue">操作</td>
						</tr>
					<%
						if(Equip_Info != null)
						{
							Iterator iterator = Equip_Info.iterator();
							while(iterator.hasNext())
							{
								EquipInfoBean statBean = (EquipInfoBean)iterator.next();
								String TId = statBean.getTId();
								String PId = statBean.getPId();
								String CName = statBean.getCName();	
								String Tel = statBean.getTel();					
								String Project_Name = statBean.getProject_Name();	
								String G_Id = statBean.getG_Id();
								
								String str_Tel = "无";
								String str_Project_Name = "无";	
								String str_G_Id = "无";
								if(Tel.length() > 0){str_Tel = Tel;}
						    if(Project_Name != null){str_Project_Name = Project_Name;}
						    if(G_Id != null){str_G_Id = G_Id;}
						    String CTime = "";
						    if(statBean.getCTime() != null)
						    {
						    	CTime = statBean.getCTime().substring(0,16);
						    }
						    String Value = "";
						    if(statBean.getValue() != null)
						    {
						    	Value = statBean.getValue();
						    }
								sn ++;
						%>
					
					  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
							 <td align=center style="cursor:hand " onmouseout="this.style.color='#000000';" onmouseover="this.style.color='#FF0000';"  title="点击查看" onClick="doEdit('<%=PId%>','<%=TId%>','<%=statBean.getProject_Id()%>','<%=G_Id%>','<%=Tel%>')"><U><%=sn%></U></td>
					     <td align=center><%=PId%></td>
					     <td align=center><%=CName%></td>
					     <td align=center><%=str_Tel%></td>
					     <td align=center><%=str_Project_Name%></td>
					     <td align=center><%=str_G_Id%></td>
					     <%
					     if(!CTime.equals("") && CTime.substring(0,10).equals(BDate))
					     {
					     %>
					     <td align=center><%=CTime%></td>
					     <%
					     }
					  	 else
					  	 {
					  	 %>
					  	 <td style="color:red" align=center><%=CTime%></td>
					  	 <%
					  	 }
					     %>
					     <td align=center><%=Value%></td>
					     <td align=center>
					     	 <a  style="color:blue" onClick="compare_Time('<%=TId%>')" href="#">对时</a>&nbsp
					     	 <a  style="color:blue" onClick="restart('<%=TId%>')" href="#">重启</a>
					     </td>
						</tr>
						<%
							}
						}
						%>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="0">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>
// 格式化时间
function formatDate(now) { 
	var year=now.getFullYear(); 
	var month=now.getMonth()+1; 
	var date=now.getDate(); 
	var hour=now.getHours(); 
	var minute=now.getMinutes(); 
	var second=now.getSeconds(); 
	return year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second; 
}

function doAdd()
{
	location = "Equip_Info_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pId, tId, pProject, pG_Id, pTel)
{
	location = "Equip_Info_Edit.jsp?Sid=<%=Sid%>&PId="+pId+"&TId="+tId+"&Project="+pProject+"&G_Id="+pG_Id+"&Tel="+pTel;
}

var reqRestart = null;
function restart(pId)
{
	if(window.XMLHttpRequest)
  {
    reqRestart = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqRestart = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRestart.onreadystatechange = function(){
	  var state = reqRestart.readyState;
	  if(state == 4)
	  {
	    if(reqRestart.status == 200)
	    {
	      var Resp = reqRestart.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	alert("下发指令成功！")
	    	}
	    	else
	    	{
	    		alert("失败！")	
	    	}
	    }
	  }
	}
	var url = "Equip_Restart.do?Sid=<%=Sid%>&PId="+pId;
	reqRestart.open('POST',url,false);
	reqRestart.send(null)
}

var reqCompareTime = null;
function compare_Time(pId)
{
	if(window.XMLHttpRequest)
  {
    reqCompareTime = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //若IE6.0或5.5
	{
    reqCompareTime = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqCompareTime.onreadystatechange = function(){
	  var state = reqCompareTime.readyState;
	  if(state == 4)
	  {
	    if(reqCompareTime.status == 200)
	    {
	      var Resp = reqCompareTime.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	alert("下发指令成功！")
	    	}
	    	else
	    	{
	    		alert("失败！")	
	    	}
	    }
	  }
	}
	var url = "Equip_Compare_Time.do?Sid=<%=Sid%>&PId="+pId;
	reqCompareTime.open('POST',url,false);
	reqCompareTime.send(null)
}


</SCRIPT>
</html>