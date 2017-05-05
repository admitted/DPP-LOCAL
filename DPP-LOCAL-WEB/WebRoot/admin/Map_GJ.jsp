<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�ܾ���ѯ</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>
<!--Zdialog-->
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>


<script type="text/javascript" src="../easyui/jquery.min.js"></script>

<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>


<!--BanRightClick-->
<script language=javascript> document.oncontextmenu=function(){window.event.returnValue=false;};</script>

<style>
	html{height:100%}
	body{height:100%; margin:0px; padding:0px}
	#container{height:100%}
  html,body{width:100%; height:100%; margin:0; padding:0;}/*���뽫���������һ���߶�*/
  .mesWindow{border:#C7C5C6 1px solid;background:#CADFFF;}
  .mesWindowTop{background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{ position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}

  #news_info
  {

  }
</style>
</head>
<%
	String       Sid          = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String       pProject_Id  = CommUtil.StrToGB2312(request.getParameter("pProject_Id"));
	String       Func_Type_Id = CommUtil.StrToGB2312(request.getParameter("Func_Type_Id"));
	UserInfoBean UserInfo     = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);	
	CurrStatus   currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList    Project_Info = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	
  int sn = 0;
	//��ʼ������
	double Longitude = 120.201967;
	double Latitude  = 30.276438;
	int MapLev = 18;
	String Pro_Id = "";
	
	if(Project_Info != null && pProject_Id != null ){
			Iterator iterator = Project_Info.iterator();
			while(iterator.hasNext()){
					ProjectInfoBean sBean = (ProjectInfoBean)iterator.next();
				  if(sBean.getId().equals(pProject_Id)){
				     Longitude	= 	Float.parseFloat(sBean.getLongitude());
				     Latitude  	= 	Float.parseFloat(sBean.getLatitude());
				     MapLev     =   Integer.parseInt(sBean.getMapLev());
				  }
			}
	 }	

%>
<body style="background:#CADFFF">
	<div id="container">	</div>
	<!-- ��ҳ�� -->
		<div id='news_info' style='position:absolute;width:200px;height:23px;right:14px;top:0px;background-color:#FFFFFF;overflow:auto;'>
		  <form  name="gj_class" >
		  	<select id="Project_Select" name="Project_Select" style="width:49%;height:23px" onChange="doReresh()"> 									  
							 <%	
 	                if(Project_Info != null){
		  								Iterator iterator = Project_Info.iterator();
											while(iterator.hasNext()){
											ProjectInfoBean statBean = (ProjectInfoBean)iterator.next();
										  Pro_Id   = statBean.getId();
											String Pro_Name = statBean.getCName();										
							 %>
								    <option value="<%=Pro_Id%>" <%=pProject_Id.equals(Pro_Id)?"selected":""%>> <%=Pro_Name%></option>
							 <%
		    						 }
									}
							 %>
				</select>
				<select id="GJ_Select" name="GJ_Select" style="width:48%;height:23px" onChange="doReresh()"> 									  
						<option value="J"   <%=Func_Type_Id.equals("J")?"selected":""%>   >�����ܵ�ͼ</option>		
					  <option value="YJ"  <%=Func_Type_Id.equals("YJ")?"selected":""%>  >��ˮ����ͼ</option>
					  <option value="WJ"  <%=Func_Type_Id.equals("WJ")?"selected":""%>  >��ˮ����ͼ</option>
				</select>
		  </form>
	  </div>
	
</body>
<input id="DelFlag" type="hidden" value="0">
<SCRIPT LANGUAGE=javascript>
	
	function doOpen()
	{
		if(document.getElementById('news_info').style.display == '')
		{
			document.getElementById('news_img').src = '../skin/images/map2open.gif';
			document.getElementById('news_img').title = '����';
			document.getElementById('news_info').style.display = 'none';
		}
		else
		{
			document.getElementById('news_img').src = '../skin/images/map2close.gif';
			document.getElementById('news_img').title = 'չ��';
			document.getElementById('news_info').style.display = '';
		}
	}

	
//������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	window.addEventListener('onorientationchange' in window ? 'orientationchange' : 'resize', setHeight, false);
	setHeight();
}
function setHeight()
{
	document.getElementById('container').style.height = document.body.offsetHeight + 'px';
}

//�����ͼ
	var map = new BMap.Map("container");                        //������ͼʵ��
	//map.setMapType(BMAP_HYBRID_MAP);                          //Ĭ������Ϊ���ǡ�·��һ��
	point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);      //�������ĵ����꣬Ĭ��Ϊ��һ����ҵ
	map.centerAndZoom(point, <%=MapLev%>);                      //��ʼ����ͼ���������ĵ�����͵�ͼ����
	map.addControl(new BMap.NavigationControl());               //���һ��ƽ�����ſؼ���λ�ÿ�ƫ�ơ���״�ɸı�
	map.addControl(new BMap.ScaleControl());                    //���һ�������߿ؼ���λ�ÿ�ƫ��[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
	map.addControl(new BMap.OverviewMapControl());              //���һ������ͼ�ؼ���λ�ÿ�ƫ��
	//map.addControl(new BMap.MapTypeControl());                //��ӵ�ͼ���ͱ任(��ͼ-����-��ά)��λ�ÿ�ƫ��
	map.enableScrollWheelZoom();                                //���ù��ַŴ���С
	
	var gjArray = new Array();
	function gjGet(arrPerson,objPropery,objValue)
	{
   return $.grep(arrPerson, function(cur,i){
   				if(objValue == cur[objPropery])
          	return cur[objPropery];
       });
	}
	

//1.��ӵ�ͼ�һ���ӱ�ע
map.addEventListener("rightclick", function(e)
{
 	doRightClick(e);
});

//2.��Ӷ����עͼ��
function addGJMarker(point, pCorp_Id, pCName, pType)
{
	/*
	if(0 != pType){
		var pIcon  = '../skin/images/map_gj_yellow_7.gif';
	}else{
		var pIcon  = (((pCorp_Id.indexOf('YJ')) < 0)?'../skin/images/map_gj_red_6.gif':'../skin/images/map_gj_blue_6.gif');
  }
  */
  //pType�У���һλ��ʾ�����豸���ڶ�λ��ʾ���յ�
	var pX,pY;
  if(pType.substring(0,1) == "1") //���豸
  {
  	if(pType.substring(1,2) == "0")
  	{
  		pX = pY = 8;
  		var pIcon  = '../skin/images/map_equip_start.gif';
  	}
  	else if(pType.substring(1,2) == "1")
		{
			pX = pY = 6;
			var pIcon  = '../skin/images/map_equip_middle.gif';
		}
		else
		{
			pX = pY = 8;
			var pIcon  = '../skin/images/map_equip_end.gif';
		}
  }
  else
  {
		if(pCorp_Id.substring(0,2) == "YJ")				//���豸 �꾮
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_yj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_yj_middle.gif';
			}
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_yj_end.gif';
			}
		}
		else if(pCorp_Id.substring(0,2) == "WJ") //���豸 �۾�
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_wj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_wj_middle.gif';
			}
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_wj_end.gif';
			}
		}
		else  //���豸 �۾�
		{
	  	if(pType.substring(1,2) == "0")
	  	{
	  		pX = pY = 8;
	  		var pIcon  = '../skin/images/map_hj_start.gif';
	  	}
	  	else if(pType.substring(1,2) == "1")
			{
				pX = pY = 6;
				var pIcon  = '../skin/images/map_hj_middle.gif';
			}
			else
			{
				pX = pY = 8;
				var pIcon  = '../skin/images/map_hj_end.gif';
			}
		}
  }
  
	var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
 	var marker = new BMap.Marker(point, {icon: myIcon});
 	var myLabel= new BMap.Label(pCName, {offset:new BMap.Size(0, pY)});
 	
 	myLabel.setStyle
 	({
 		fontSize:"11px",
 		font:"bold 10pt/12pt",
 		border:"0px",
 		color:"black",
 		textAlign:"center",
 		background:"yellow",
 		cursor:"pointer"
 	});
 	/*if(pType.substring(0,1) == "1")
 	{
 		marker.setLabel(myLabel);//���ֱ��
 	}*/
 	map.addOverlay(marker);
 	
  //���
 	marker.addEventListener("click", function()
 	{
 		doGJDefence(pCorp_Id, pType);
	});
	
	//��ק 
	/*marker.enableDragging(); 
	marker.addEventListener("dragend", function(e)
	{  
		doDragging(pCorp_Id, e.point.lng, e.point.lat, pType);  	
	});*/
	
}

function addGXMarker(polyline,gxId)
{
	 map.addOverlay(polyline);
	// polyline.addEventListener("click", function()
 	//{
 	//	doGXDefence(gxId);
  //});
} 
	
//�ܾ�״̬���
var reqRealGJ = null;
function RealGJStatus()
{
	if(window.XMLHttpRequest)
  {
    reqRealGJ = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //��IE6.0��5.5
	{
    reqRealGJ = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealGJ.onreadystatechange = function(){
	  var state = reqRealGJ.readyState;
	  if(state == 4)
	  {
	    if(reqRealGJ.status == 200)
	    {
	      var Resp = reqRealGJ.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	//1.ɾ��
	      	gjArray = [];
					map.clearOverlays();      	
	      	//2.���
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		  var sublist = list[i].split("|");
	      		  if(sublist[0].indexOf(document.getElementById("GJ_Select").value)< 0){
      		  	 continue;
      		    }
	      		  var point = new BMap.Point(sublist[1], sublist[2]);  
	      		  var gjObj = new Object();

	      		  gjObj.tId = sublist[0];
	      		  gjObj.tPoint = point;
	      		  gjArray.push(gjObj);
    		  
	      			var pName = 'ˮλ : ';
						  addGJMarker(point, sublist[0], pName+sublist[4], sublist[3]);
							//;TSGYJ005-3|120.203581|30.276107|0|0;
	      	}
	      }
	    }
	  }
	};
	var url = "Admin_ToPo_GJ.do?Cmd=21&Id="+document.getElementById("Project_Select").value+"&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGJ.open('POST',url,false);
	reqRealGJ.send(null);
}

//����״̬���
var reqRealGX = null;
function RealGXStatus()
{
	if(window.XMLHttpRequest)
  {
    reqRealGX = new XMLHttpRequest();
  }
	else if(window.ActiveXObject) //��IE6.0��5.5
	{
    reqRealGX = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqRealGX.onreadystatechange = function(){
	  var state = reqRealGX.readyState;
	  if(state == 4)
	  {
	    if(reqRealGX.status == 200)
	    {
	      var Resp = reqRealGX.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {

	      	//2.���
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{

	      		var sublist = list[i].split("|");
	      		if(sublist[1].indexOf(document.getElementById("GJ_Select").value)< 0){
      		  	 continue;
      		  }    		  
      		  
    		  	var gxId = sublist[0];
    		  	var gjStartId = sublist[1];
    		  	var gjEndId = sublist[2];
    		  	var gjStart = gjGet(gjArray, "tId", gjStartId);      		  	
      		  var gjEnd   = gjGet(gjArray, "tId", gjEndId);      		  
      		  if(null == gjStart[0] || null == gjEnd[0]){continue;}
      		  var color = "";
      		  if(gxId.indexOf("WG") >= 0)
      		  {
						  color = "red";
      		  }
      		  else if(gxId.indexOf("YG") >= 0)
      		  {
							color = "blue";
      		  }
      		  else if(gxId.indexOf("HG") >= 0)
      		  {
							color = "green";
      		  }
      		  var polyline = new BMap.Polyline([gjStart[0].tPoint, gjEnd[0].tPoint], {strokeColor:color, strokeWeight:2.7, strokeOpacity:0.9});
      		  addGXMarker(polyline,gxId);
	      	}
	      }
	    }
	  }
	};
	var url = "Admin_ToPo_GX.do?Cmd=21&Id="+document.getElementById("Project_Select").value+"&Sid=<%=Sid%>&currtime="+new Date();
	reqRealGX.open('POST',url,false);
	reqRealGX.send(null);
}
RealGJStatus()
RealGXStatus()


//�ҵ���¼�
/*var reqUnMarke = null;
function doRightClick(e)
{
	//��ȡδ���  XMLHttpRequest ���������ں�̨��������������ݡ�
	if(window.XMLHttpRequest)
  { // code for all new browsers
		reqUnMarke = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{// code for IE5 and IE6
		reqUnMarke = new ActiveXObject("Microsoft.XMLHTTP");
	}
	reqUnMarke.onreadystatechange = function()
	{
	  var state = reqUnMarke.readyState;
	  if(state == 4)
	  {// 4 = "loaded"
	    if(reqUnMarke.status == 200)
	    {// 200 = OK
	      var Resp = reqUnMarke.responseText;
	      if(null != Resp && Resp.substring(0,4) == '0000')
	      {
	      	//վ��
	      	var list = Resp.substring(4).split(';');
					var content = "<select id='Id' name='Id' style='width:220px;height:20px;'>";
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		content += "<option value='"+ list[i] +"'>"+ list[i] +"</option>";
	      	}
					content += "</select>";
					content += "<input type='button' value='��ע�ܾ�' onClick=\"doAddMarke('0', "+e.point.lng+", "+e.point.lat+")\">";
					var opts = 
					{
					  width : 350, // ��Ϣ���ڿ��  
					  height: 60,  // ��Ϣ���ڸ߶�  
					  title : ""   // ��Ϣ���ڱ���
					}
					var infoWindow = new BMap.InfoWindow(content, opts);//������Ϣ���ڶ���  
					map.openInfoWindow(infoWindow, e.point);            //����Ϣ����
	      }  
	      else
	      {
	    		return;
	      }   
	    }
	    else
	    {
	    	return;
	    }
	  }
	};
	var url = "Admin_ToPo_GJ.do?Cmd=23&Sid=<%=Sid%>&Project_Id=<%=pProject_Id%>&currtime="+new Date();
	reqUnMarke.open("POST",url,false);
	reqUnMarke.send(null);
	return true;
}

//��ӱ�ע
var reqAdd = null;
function doAddMarke(pType, Lng, Lat)
{
	if(document.getElementById('Id').value.length < 1)
	{
		alert('��ѡ��Ҫ��ע��վ��!');
		return;
	}
	var Id = document.getElementById('Id').value;
	if(confirm('ȷ����ӱ�ע?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqAdd.onreadystatechange = function()
		{
		  var state = reqAdd.readyState;
		  if(state == 4)
		  {
		    if(reqAdd.status == 200)
		    {
		      var Resp = reqAdd.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	map.closeInfoWindow();
		      	var point = new BMap.Point(Lng, Lat);
						addGJMarker(point, Id, Id, '7', '7', pType);
		      	alert('��ӱ�ע�ɹ�!');
		    		return;
		      }
		      else
		      {
		      	alert('��ӱ�עʧ��!');
		    		return;
		      }
		    }
		    else
		    {
		    	alert('��ӱ�עʧ��!');
		    	return;
		    }
		  }
		};
		var url = "Admin_Drag_GJ.do?Cmd=17&Sid=<%=Sid%>&Id="+Id+"&Project_Id="+document.getElementById("Project_Select").value+"&Longitude="+Lng+"&Latitude="+Lat+"&currtime="+new Date();
		reqAdd.open("POST",url,false);
		reqAdd.send(null);
		return true;
	}
}

//��ק������½ӿ�
var reqDrg = null;
function doDragging(pId, pLng, pLat, pType)
{
	if(confirm('ͬ�����µ�ǰվ������?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqDrg = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDrg = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqDrg.onreadystatechange = function()
		{
		  var state = reqDrg.readyState;
		  if(state == 4)
		  {
		    if(reqDrg.status == 200)
		    {
		      var Resp = reqDrg.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	alert('����ͬ�����³ɹ�!');
		      	RealGJStatus();
		      	RealGXStatus();
		    		return;
		      }  
		      else
		      {
		      	alert('����ͬ������ʧ��!');
		    		return;
		      }   
		    }
		    else
		    {
		    	alert('����ͬ������ʧ��!');
		    	return;
		    }
		  }                 
		};
		var url = "Admin_Drag_GJ.do?Cmd=15&Sid=<%=Sid%>&Id="+pId+"&Project_Id="+document.getElementById("Project_Select").value+"&Longitude="+pLng+"&Latitude="+pLat+"&currtime="+new Date();
		reqDrg.open("POST",url,false);
		reqDrg.send(null);
		return true;
	}
}
function writeObj(obj){ 
 var description = ""; 
 for(var i in obj){ 
  var property=obj[i]; 
  description+=i+" = "+property+"\n"; 
 } 
 alert(description); 
} */
//�����鿴�ܾ��ӿ�
function doGJDefence(pId, pType)
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 550;
	Pdiag.Height = 375;
	Pdiag.Title = "�ܾ�����: "+pId;
	Pdiag.URL = "Admin_DevGJ_Info.do?Sid=<%=Sid%>&Cmd=6&Func_Project_Id="+document.getElementById("Project_Select").value + "&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		Pdiag.close();	//�رմ���
    //RealStatus();		//ҳ��ˢ��
	};
	Pdiag.show();
}

//�����鿴�ܾ��ӿ�(ԭ)
/*function doGJDefence(pId, pType)
{
	
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 180;
	Pdiag.Height = 158;
	Pdiag.Title = "�ܾ�����";
	Pdiag.URL = "Admin_DevGJ_Info.do?Cmd=6&Sid=<%=Sid%>&Func_Project_Id=<%=pProject_Id%>&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		
		Pdiag.close();	//�رմ���		
		if(1 == document.getElementById('DelFlag').value){
			RealGJStatus();	//ҳ��ˢ��
			RealGXStatus();	//ҳ��ˢ�� 
			document.getElementById('DelFlag').value = 0;
		}	
	};
	Pdiag.show();
}*/
//�����鿴���߽ӿ�
function doGXDefence(pId)
{
	
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 160;
	Pdiag.Height = 135;
	Pdiag.Title = "��������";
	Pdiag.URL = "Admin_DevGX_Info.do?Cmd=3&Sid=<%=Sid%>&Id="+pId;
	Pdiag.CancelEvent=function()
	{
		Pdiag.close();	//�رմ���
		//RealGJStatus();		//ҳ��ˢ��
	};
	Pdiag.show();
}

function doReresh()
{
	this.location = "Map_GJ.jsp?pProject_Id="+document.getElementById("Project_Select").value+"&Func_Type_Id="+document.getElementById("GJ_Select").value+"&Sid=<%=Sid%>";
}

</SCRIPT>
</html>