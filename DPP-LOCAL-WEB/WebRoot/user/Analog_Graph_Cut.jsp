<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="http://cdn.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
<script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts-more.js"></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Id  = CommUtil.StrToGB2312(request.getParameter("Id"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  
	ArrayList    Analog_Graph_Cut_GX   = (ArrayList)session.getAttribute("Analog_Graph_Cut_GX_" + Sid);
	ArrayList    Analog_Graph_Cut_GJ   = (ArrayList)session.getAttribute("Analog_Graph_Cut_GJ_" + Sid);
	String       Analog_WaterLev       = (String)session.getAttribute("Analog_WaterLev_" + Sid);
	java.text.DecimalFormat   df   	 = new java.text.DecimalFormat("#.00");  
	
	String Data_Line_a = "";
	String Data_Line_b = "";
	String Data_Line_c = "";
	String Data_Line_d = "";
	
	String Data_Area_A = "";

	String Data_Bar_A	= "";
	String Data_Bar_B	= "";
	String Data_Bar_C	= "";
	String Data_Bar_D	= "";	
	String Data_Bar_E	= "";
	
%>
<body  style=" background:#FFFFFF">
	
<form name="Analog_Graph_Cut" action="Analog_Graph_Cut.do" method="post" target="mFrame" enctype="multipart/form-data">
  <div id="container" style="min-width:200px;min-height:320px"></div>
</form>
</body>
<script LANGUAGE="javascript">
	
	
function writeObj(obj){ 
 var description = ""; 
 for(var i in obj){ 
  var property=obj[i]; 
  description+=i+" = "+property+"\n"; 
 } 
 alert(description); 
} 

	var noWaterFlag = 0;
	
	var stackCnt = 0;
	var dataArea = new Array();
	var gjArray = new Array();
	var gxArray = new Array();
	var xAxArray = new Array();
	
	var Data_Line_a = new Array();	//井顶部-路面				虚线
	var Data_Line_b = new Array();	//管线顶部					实线
	var Data_Line_d = new Array();	//管线底部					实线
	
	var Data_Bar_A = new Array();		//井中无水区域 			灰色
	var Data_Bar_C = new Array();		//井中有水区域 			蓝色
	var Data_Bar_E = new Array();		//井底以下到海平面 	白色
	
	var Data_Area_A = new Array();	//管线中有水区域		蓝色
	
	var WaterLev = new Array();     //计算出来的水位
	
	var min_Height = 100;		// 最低底高

function doYesWater(time)
{
	var Analog_WaterList = "<%= Analog_WaterLev %>".split(";");
	var Analog_WaterLev = "";
	for(var i = 0; i < Analog_WaterList.length; i ++)
	{
		if(i == time)
		{
			
			Analog_WaterLev = Analog_WaterList[i];
		}
	}
	WaterLev = [];
	if(Analog_WaterLev != null)
  {
		WaterLev = Analog_WaterLev.substring(5).split('|');
  }
	noWaterFlag = 0;
	stackCnt = 0;
	dataArea = [];
	gjArray = [];
	gxArray = [];
	xAxArray = [];
	Data_Line_a = [];
	Data_Line_b = [];
	Data_Line_d = [];
	Data_Bar_A = [];
	Data_Bar_C = [];
	Data_Bar_E = [];
	Data_Area_A = [];
	
	var i = 0;
	//关键字获取数组元素
	function arrayGet(arrPerson,objPropery,objValue)
	{
	 return $.grep(arrPerson, function(cur,i){
	 				if(objValue == cur[objPropery])
	        	return cur[objPropery];
	     });
	}
	var AnalogType = Analog_WaterLev.substring(0,2);
<%
	if(null != Analog_Graph_Cut_GJ)
	{
		Iterator iter = Analog_Graph_Cut_GJ.iterator();
		
		while(iter.hasNext())
		{
			DevGJBean gjBean = (DevGJBean)iter.next();
	%>
			var gjObj 				= new Object();
			gjObj.tId 				= "<%=gjBean.getId()%>";
			gjObj.Flag 				= "<%=gjBean.getFlag()%>";
			gjObj.Base_Height = "<%=gjBean.getBase_Height()%>";
			gjObj.Top_Height 	= "<%=gjBean.getTop_Height()%>";
			if((gjObj.tId).substring(0,2)==AnalogType){
				gjObj.WaterLev = WaterLev[i];
				i ++;
				gjArray.push(gjObj);
			}
			if(gjObj.Base_Height*1 < min_Height)
			{
				min_Height = gjObj.Base_Height;
			}
	<%
		}
	} 	
	if(null != Analog_Graph_Cut_GX)
	{
		Iterator it = Analog_Graph_Cut_GX.iterator();
		while(it.hasNext())
		{
			DevGXBean gxBean = (DevGXBean)it.next();
%>
			var gxObj 					= new Object();
			gxObj.tId 					= "<%=gxBean.getId()%>";
			gxObj.Diameter 			= "<%=gxBean.getDiameter()%>";
			gxObj.Length 				= "<%=gxBean.getLength()%>";
			gxObj.Start_Id 			= "<%=gxBean.getStart_Id()%>";
			gxObj.End_Id				= "<%=gxBean.getEnd_Id()%>";
			gxObj.Start_Height	= "<%=gxBean.getStart_Height()%>";
			gxObj.End_Height		= "<%=gxBean.getEnd_Height()%>";
			gxArray.push(gxObj);			
<%
		}
	}				
%>					
	var xAx = 0.0;
	var nextGX_Base_Height;
	var preGX_Base_Height;
	var preGX_Diameter;
	var tmpGJ = arrayGet(gjArray, "tId", "<%=Id%>")[0];
	while(true)
	{		
		var tmpGX;

		var gxWater_Lev;
		if(2 != tmpGJ.Flag)		//不是终点管井 重新赋值 如果是 沿用之前tmpGX
		{
			tmpGX = arrayGet(gxArray, "Start_Id", tmpGJ.tId)[0];			
			if(null == tmpGX){break;}
			nextGX_Base_Height = tmpGX.Start_Height;
		}
		
		if(0 == noWaterFlag)//有水位图
		{			
			var gxBase_Height = nextGX_Base_Height;
			if(2 == tmpGJ.Flag) //终点管井
			{
				gxBase_Height = preGX_Base_Height;
			}

		  var gxTop_Height = parseFloat(gxBase_Height) + parseFloat(tmpGX.Diameter);
		  var gjWater_Lev  = parseFloat(tmpGJ.WaterLev);
		  
	  	if(gjWater_Lev > tmpGJ.Top_Height)
	  	{
	  		gjWater_Lev = tmpGJ.Top_Height;
	  	}
		  
		  var gxWater_Lev = 0.0;
		  if(gxTop_Height < gjWater_Lev)	//水位超出管线上延，取管线上延高度显示
		  {
		  	gxWater_Lev = gxTop_Height;
		  }
		  else if(gxBase_Height < gjWater_Lev)	//水位在管线上延&管线下延之间，取管井水位高度显示
		  {
		  	gxWater_Lev = gjWater_Lev;
		  }
		  else			//水位低于管线下延,取管线下延高度显示
		  {
		  	gxWater_Lev = gxBase_Height;
		  	gjWater_Lev = gxBase_Height;
		  }
		  /**********前后管线高度or直径不一致情况 2016/10/21 lsd **********/
		  if(0 != xAx && (preGX_Base_Height != gxBase_Height || preGX_Diameter != tmpGX.Diameter))
		  {
		  	var preGx_Water_Lev;
		  	var preGx_Top_Height = parseFloat(preGX_Base_Height) + parseFloat(preGX_Diameter);
		  	
			  if(preGx_Top_Height < gjWater_Lev)	//水位超出管线上延，取管线上延高度显示
			  {
			  	preGx_Water_Lev = preGx_Top_Height;
			  }
			  else			//水位低于管线下延,取管线下延高度显示
			  {
			  	preGx_Water_Lev = preGX_Base_Height > gjWater_Lev ? preGX_Base_Height:gjWater_Lev;
			  }
		  	Data_Area_A.push([xAx, parseFloat(preGX_Base_Height), parseFloat(preGx_Water_Lev)]);
		  	
		  }
		   /********************************************************************/
		  Data_Area_A.push([xAx, parseFloat(gxBase_Height), parseFloat(gxWater_Lev)]);
		}
		
		Data_Line_a.push([xAx, parseFloat(tmpGJ.Top_Height)]);
		Data_Bar_A.push([xAx, gjWater_Lev, parseFloat(tmpGJ.Top_Height)]);	
	  Data_Bar_C.push([xAx, parseFloat(tmpGJ.Base_Height), gjWater_Lev]);
		//Data_Bar_E.push([xAx, parseFloat(tmpGJ.Base_Height)]);
		
		//push pre管线的终端高度 xAx不变 -- 2016.7.19.lsd
		if(0 != xAx)//第一个窨井没有终端标高
		{
			Data_Line_b.push([xAx, parseFloat(preGX_Base_Height) + parseFloat(preGX_Diameter)]);
			Data_Line_d.push([xAx, parseFloat(preGX_Base_Height)]);
		}
		
		if(2 == tmpGJ.Flag)
		{//最后一个管井没有起端标高
			//组织标签数据（窨井ID）
			var xAxObj = new Object();
			xAxObj.xAx = xAx;
			xAxObj.tId = tmpGJ.tId.substring(5,8);
			xAxArray.push(xAxObj);
			break;
		}
		else
		{
			//push next管线的起端高度 xAx不变 -- 2016.7.19.lsd
			Data_Line_b.push([xAx, parseFloat(nextGX_Base_Height) + parseFloat(tmpGX.Diameter)]);
			Data_Line_d.push([xAx, parseFloat(nextGX_Base_Height)]);
			//组织标签数据（窨井ID）
			var xAxObj = new Object();
			xAxObj.xAx = xAx;
			xAxObj.tId = tmpGJ.tId.substring(5,8);
			xAxArray.push(xAxObj);
			
			//组织X轴坐标（根据管线长度累加）
			xAx += parseFloat(tmpGX.Length);
		}
		//获取End_Height
		preGX_Base_Height = tmpGX.End_Height;
		preGX_Diameter = tmpGX.Diameter;
		//获取下一个循环的管井数据
		tmpGJ = arrayGet(gjArray, "tId", tmpGX.End_Id)[0];
	}//while
				/**********数据b&数据c&数据d
				Data_GX_Top 	+= df.format(Float.parseFloat(gxBaseHeight)+Float.parseFloat(gxBean.getDiameter()))+",";									
				Data_WaterLev += df.format(Float.parseFloat(gjBaseHeight)+Float.parseFloat(gjBean.getCurr_Data()))+",";		
				Data_GX_Base 	+= gxBaseHeight +",";
								
				Data_Line_a += gjTop_Height + ","; 
				Data_Line_b += df.format(Float.parseFloat(nextGX_Base_Height)+Float.parseFloat(gxDiameter))+",";	
				Data_Line_c += df.format(Float.parseFloat(gjBase_Height)+Float.parseFloat(gjCurr_Data))+",";
				Data_Line_d += nextGX_Base_Height +",";
				
				Data_Bar_A += df.format(Float.parseFloat(gjTop_Height)-Float.parseFloat(gjBase_Height))+",";
				Data_Bar_C += gjCurr_Data+",";	
				Data_Bar_E += gjBase_Height +",";
				
				Data_Area_A += "[" + nextGX_Base_Height + ", " + df.format(Float.parseFloat(gjBase_Height)+Float.parseFloat(gjCurr_Data)) + "], ";
				
 			***********/
	var seriesData = [];
	if(0 == noWaterFlag)
	{
		seriesData = [{
          	type:'line',
          	color:'black',
            name: '',
            lineWidth: 1,
            data: Data_Line_a,
            marker: {                                                     
            	enabled:false
            },
            dataLabels: {
                enabled: true,
                formatter: function () {
                	var tmpObj;
                	if(0 ==  this.x)
                	{
                		tmpObj = xAxArray[0];
                	}
                	else
                	{
                		tmpObj = arrayGet(xAxArray, "xAx", this.x)[0];
                	}

                	return tmpObj.tId;
                },
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        }, {
            name: 'Range',
            data: Data_Area_A,
            fillColor:'#008AEC',
            lineColor:'#008AEC',
            dashStyle:'DashDot',
            lineWidth:0,
            type: 'arearange'
      	}, {
          	type:'line',
          	color:'black',
            name: '',
            lineWidth: 1,
            data: Data_Line_b,
            marker: {                                                     
            	enabled:false
            } 
        }, {
          	type:'line',
          	color:'black',
            name: '',
            lineWidth: 1,
            data: Data_Line_d,
            marker: {                                                     
            	enabled:false
            }
        }, {
        	  type: 'columnrange',
            name: '',
            color: 'gray',
            data: Data_Bar_A,
        }, {
        		type: 'columnrange',
            name: '',
            color: '#008AEC',
            data: Data_Bar_C,       
        }]
	}
//writeObj(Data_Bar_A)
//writeObj(Data_Line_a)
	$(function () {
    Highcharts.setOptions({
        // 所有语言文字相关配置都设置在 lang 里
        lang: {
            resetZoom: '重置',
            resetZoomTitle: '重置缩放比例'
        }
    });
    $('#container').highcharts({
        chart: {
        		zoomType: 'x',
            selectionMarkerFill: 'rgba(0,0,0, 0.2)',
            resetZoomButton: {
                // 按钮定位
                position:{
                    align: 'right', // by default
                    verticalAlign: 'top', // by default
                    x: 0,
                    y: 0
                },
                // 按钮样式
                theme: {
                    fill: 'white',
                    stroke: 'silver',
                    r: 0,
                    states: {
                        hover: {
                            fill: '#41739D',
                            style: {
                                color: 'white'
                            }
                        }
                    }
                }
            },
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },
        xAxis: {
            tickmarkPlacement: 'on',
            title: {
                text: '距离(m)'
            }
        },
        yAxis: {
            min: min_Height,
            title: {
                text: '标高(m)'
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
            formatter: function() {
                return false;
            }
        },
        plotOptions: {
        	
        	//关闭动画
            series: {
            	animation: false
            },
        		
            columnrange: {
            		pointPadding: 0,
       					borderWidth: 0,
        				pointWidth: 10,
                stacking: 'normal'
            }
        },
        series: seriesData
    });
});
}


doYesWater(1);
</script>

</html>