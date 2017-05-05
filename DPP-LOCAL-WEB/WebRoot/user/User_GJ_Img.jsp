<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>窨井图</title>
<link   type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/jquery.min.js"></script>
<script type="text/javascript" src="../skin/js/highcharts.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>

<%
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  
	DevGJBean User_DevGJ_Info = (DevGJBean)session.getAttribute("User_DevGJ_Info_" + Sid);
  
  String GJ_Id = request.getParameter("GJ_Id");
  String Project_Id = request.getParameter("Project_Id");
  String In_Img = "";
  String Out_Img = "";

  if(User_DevGJ_Info != null){
		GJ_Id = User_DevGJ_Info.getId();
		Project_Id = User_DevGJ_Info.getProject_Id();
		In_Img = User_DevGJ_Info.getIn_Img();
		Out_Img = User_DevGJ_Info.getOut_Img();
  }
  if(In_Img == null || In_Img.trim().equals("")){
  	In_Img = "no_img.gif";
  }
  if(Out_Img == null || Out_Img.trim().equals("")){
  	Out_Img = "no_img.gif";
  }

	%>
</head>
<body>
<form name='User_GJ_Scene' action='User_GJ_Scene.do' method='post' target='mFrame' enctype="multipart/form-data">
	<table border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
		<!--<tr height=30>
    	<td>
	    	<input title='请选择窨井图' style="position:absolute;width:200px;height:20px;right:200px;top:5px;" type='file'   name='file'> 
	    	<input onclick='doUpload()' style="position:absolute;width:100px;height:20px;right:20px;top:5px;"  type='button' value='更新窨井图'>
    	</td>
   	</tr>-->
		<tr style="width:50%;height:50%;">
    	<td align='right' style="width:50%;height:50%;">
    		<img style="background:white;width:200px;height:140px;" src="../skin/images/GJ_Img/<%=In_Img%>" alt="暂无窨井图" title="窨井图" />
    	</td>
    	<td style="width:50%;height:50%;"></td>
	  </tr>
	  <tr style="width:50%;height:50%;">
	  	<td style="width:50%;height:50%;"></td>
	  	<td style="width:50%;height:50%;">
	  		<img style="background:white;width:200px;height:140px;padding-left:5px;padding-top:5px;" src="../skin/images/GJ_Img/<%=Out_Img%>" alt="暂无窨井图" title="窨井图" />
	  	</td>
	  </tr>
  </table>
	<input type="hidden" name="Sid"          value="<%=Sid%>" >
	<input type="hidden" name="GJ_Id"        value="<%=GJ_Id%>" >
	<input type="hidden" name="Project_Id"   value="<%=Project_Id%>" >
	
</form>
</body>
<script language=javascript>
	function doUpload()
	{
		alert(User_GJ_Scene.GJ_Id.value + ',' +  User_GJ_Scene.Project_Id.value)
	  var pUrl = User_GJ_Scene.file.value;
	  if(pUrl.indexOf('.jpg') == -1 && pUrl.indexOf('.JPG') == -1 && pUrl.indexOf('.gif') == -1 && pUrl.indexOf('.GIF') == -1 && pUrl.indexOf('.bmp') == -1 && pUrl.indexOf('.BMP') == -1)
	  {
	    alert('请确认图片格式,支持jpg,gif,bmp,JPG,GIF,BMP格式!');
	    return;
	  }
	  if(confirm('确定更新窨井图?'))
	  {
	    User_GJ_Scene.submit();
	  }
	}

</script>