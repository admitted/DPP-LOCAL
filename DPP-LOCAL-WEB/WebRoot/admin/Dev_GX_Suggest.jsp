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

<!--EasyUI-->
<link rel="stylesheet" type="text/css" href="../easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../easyui/demo/demo.css">
<script type="text/javascript" src="../easyui/jquery.min.js"></script>
<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>

</head>
<%
	
	String Sid               = CommUtil.StrToGB2312(request.getParameter("Sid"));				

  
%>
<body style=" background:#CADFFF">
	
    <div style="margin:20px 0"></div>
    <div class="easyui-panel" style="width:100%;max-width:400px;padding:30px 60px;">
        <div style="margin-bottom:20px">
            <label class="label-top">管线ID查找:</label>
            <input id="easyui-combobox" class="easyui-combobox" name="language" style="width:100%;height:26px;"  data-options="
            		url:'Admin_DevGX_Suggest.do?Sid=<%=Sid%>',
						 	 	valueField:'id',    
						  	textField:'text',
						  	panelHeight:'400'
            ">
            <a href="#" onClick="doGX_Edit()">编辑</a>
        </div>
    </div>
	

</body>

<SCRIPT LANGUAGE=javascript>
//初始化下拉选框


function doGX_Edit()
{  
	var value = $('#easyui-combobox').combobox("getValue");
	window.parent.frames.mFrame.location = "Dev_GX_Edit.jsp?Id="+ value +"&Sid=<%=Sid%>";
	alert(value);
	
}

</SCRIPT>
</html>