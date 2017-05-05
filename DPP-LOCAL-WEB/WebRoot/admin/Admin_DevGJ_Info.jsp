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
<title>ˮλ����ͼ</title>
<link   type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/jquery.min.js"></script>
<script type="text/javascript" src="../skin/js/highcharts.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>

<%
	String Sid   							= CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus 		= (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	
	DevGJBean Admin_DevGJ_Info = (DevGJBean)session.getAttribute("Admin_DevGJ_Info_" + Sid);
 
 	String Project_Id = "";
 	String GJ_Id = "";
  String Curr_Data = "";
	String Material = "";
	String Base_Height = "";
	String Top_Height = "";
	String Size = "";
  String In_Img = "";
  String Out_Img = "";
  if(Admin_DevGJ_Info != null)
  {
  	GJ_Id       = Admin_DevGJ_Info.getId();
  	Project_Id  = Admin_DevGJ_Info.getProject_Id();
	  Curr_Data 	= Admin_DevGJ_Info.getCurr_Data();
		Material 		= Admin_DevGJ_Info.getMaterial();
		Base_Height = Admin_DevGJ_Info.getBase_Height();
		Top_Height 	= Admin_DevGJ_Info.getTop_Height();
		Size 				= Admin_DevGJ_Info.getSize();
		In_Img      = Admin_DevGJ_Info.getIn_Img();
		Out_Img     = Admin_DevGJ_Info.getOut_Img();
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
	<form name='Admin_GJ_Scene' action='Admin_GJ_Scene.do' method='post' target='_self' enctype="multipart/form-data">
	<table style='margin:auto'    border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
		<tr height='30' valign='bottom'>
			<!--<td width='24%' align='center'>
			    <select name='GraphType' style='width:110px;height:20px' onChange='doGraphType()'>
			    	<option value='0'>񿾮ͼ</option>
			      <option value='1'>����ͼ(��ˮλ)</option>
			      <option value='2'>ʱ��ˮλͼ</option>				      
			    </select>
			</td>-->
			<td width='80%' align='left'>
				<div style='position:absolute;width:450px;height:60px;left:52px;top:15px;down:15px'>
					����: <%=Top_Height%>&nbsp;
					�׸�: <%=Base_Height%>&nbsp;
					�ߴ磺<%=Size%>&nbsp;
					����: <%=Material%>&nbsp;
					ˮλ: <%=Curr_Data%>&nbsp;
				</div>
			</td>
			<td width='10%' align='left'>
		  	<div id="In_Img" name="In_Img" style="position:absolute;display:;width:30px;height:23px;right:20px;top:15px;">
		  		<input type="button" value="��ͼ" onClick="OutImg()">
		  	</div>
		  	<div id="Out_Img" name="Out_Img" style="position:absolute;display:none;width:30px;height:23px;right:20px;top:15px;">
		  		<input type="button" value="��ͼ" onclick="InImg()">
		  	</div>
			</td>
		</tr>
		<tr>
	  	<td align='center' colspan=2>
	  		<input title='��ѡ��񿾮ͼ' style="position:absolute;width:180px;height:20px;left:100px;" type='file'   name='file'> 
				<input onclick='doUpload()' style="position:absolute;width:100px;height:20px;"  type='button' value='����񿾮ͼ'>
	  		<div style='width:450px;heiht:300px;padding-top:25px;margin: 0 auto'>
	  			<img id="GJ_Img" style="background:#CADFFF;width:450px;height:300px" src="../skin/images/GJ_Img/<%=In_Img%>" alt="����񿾮ͼ" title="񿾮ͼ" />
	  		</div>
	  	</td>	
		</tr>	
  </table>
  <input type="hidden" name="Cmd" id="Cmd" value="14" >
  <input type="hidden" name="Sid"          value="<%=Sid%>" >
	<input type="hidden" name="GJ_Id"        value="<%=GJ_Id%>" >
	<input type="hidden" name="Project_Id"   value="<%=Project_Id%>" >
  </form>
</body>
<SCRIPT LANGUAGE=javascript>
	
	function OutImg()
	{
		document.getElementById("Cmd").value="18";
		document.getElementById("In_Img").style.display = "none";
		document.getElementById("Out_Img").style.display = "";
		document.getElementById("GJ_Img").src="../skin/images/GJ_Img/<%=Out_Img%>";
	}
	function InImg()
	{
		document.getElementById("Cmd").value="14";
		document.getElementById("In_Img").style.display = "";
		document.getElementById("Out_Img").style.display = "none";
		document.getElementById("GJ_Img").src="../skin/images/GJ_Img/<%=In_Img%>";
	}
	
	function doUpload()
	{
	  var pUrl = Admin_GJ_Scene.file.value;
	  if(pUrl.indexOf('.jpg') == -1 && pUrl.indexOf('.JPG') == -1 && pUrl.indexOf('.gif') == -1 && pUrl.indexOf('.GIF') == -1 && pUrl.indexOf('.bmp') == -1 && pUrl.indexOf('.BMP') == -1)
	  {
	    alert('��ȷ��ͼƬ��ʽ,֧��jpg,gif,bmp,JPG,GIF,BMP��ʽ!');
	    return;
	  }
	  if(confirm('ȷ������񿾮ͼ?'))
	  {
	    Admin_GJ_Scene.submit();
	  }
	}

</script>
</html>