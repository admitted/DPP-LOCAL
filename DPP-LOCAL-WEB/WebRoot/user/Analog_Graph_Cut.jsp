<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
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
	
	var Data_Line_a = new Array();	//������-·��				����
	var Data_Line_b = new Array();	//���߶���					ʵ��
	var Data_Line_d = new Array();	//���ߵײ�					ʵ��
	
	var Data_Bar_A = new Array();		//������ˮ���� 			��ɫ
	var Data_Bar_C = new Array();		//������ˮ���� 			��ɫ
	var Data_Bar_E = new Array();		//�������µ���ƽ�� 	��ɫ
	
	var Data_Area_A = new Array();	//��������ˮ����		��ɫ
	
	var WaterLev = new Array();     //���������ˮλ
	
	var min_Height = 100;		// ��͵׸�

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
	//�ؼ��ֻ�ȡ����Ԫ��
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
		if(2 != tmpGJ.Flag)		//�����յ�ܾ� ���¸�ֵ ����� ����֮ǰtmpGX
		{
			tmpGX = arrayGet(gxArray, "Start_Id", tmpGJ.tId)[0];			
			if(null == tmpGX){break;}
			nextGX_Base_Height = tmpGX.Start_Height;
		}
		
		if(0 == noWaterFlag)//��ˮλͼ
		{			
			var gxBase_Height = nextGX_Base_Height;
			if(2 == tmpGJ.Flag) //�յ�ܾ�
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
		  if(gxTop_Height < gjWater_Lev)	//ˮλ�����������ӣ�ȡ�������Ӹ߶���ʾ
		  {
		  	gxWater_Lev = gxTop_Height;
		  }
		  else if(gxBase_Height < gjWater_Lev)	//ˮλ�ڹ�������&��������֮�䣬ȡ�ܾ�ˮλ�߶���ʾ
		  {
		  	gxWater_Lev = gjWater_Lev;
		  }
		  else			//ˮλ���ڹ�������,ȡ�������Ӹ߶���ʾ
		  {
		  	gxWater_Lev = gxBase_Height;
		  	gjWater_Lev = gxBase_Height;
		  }
		  /**********ǰ����߸߶�orֱ����һ����� 2016/10/21 lsd **********/
		  if(0 != xAx && (preGX_Base_Height != gxBase_Height || preGX_Diameter != tmpGX.Diameter))
		  {
		  	var preGx_Water_Lev;
		  	var preGx_Top_Height = parseFloat(preGX_Base_Height) + parseFloat(preGX_Diameter);
		  	
			  if(preGx_Top_Height < gjWater_Lev)	//ˮλ�����������ӣ�ȡ�������Ӹ߶���ʾ
			  {
			  	preGx_Water_Lev = preGx_Top_Height;
			  }
			  else			//ˮλ���ڹ�������,ȡ�������Ӹ߶���ʾ
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
		
		//push pre���ߵ��ն˸߶� xAx���� -- 2016.7.19.lsd
		if(0 != xAx)//��һ��񿾮û���ն˱��
		{
			Data_Line_b.push([xAx, parseFloat(preGX_Base_Height) + parseFloat(preGX_Diameter)]);
			Data_Line_d.push([xAx, parseFloat(preGX_Base_Height)]);
		}
		
		if(2 == tmpGJ.Flag)
		{//���һ���ܾ�û����˱��
			//��֯��ǩ���ݣ�񿾮ID��
			var xAxObj = new Object();
			xAxObj.xAx = xAx;
			xAxObj.tId = tmpGJ.tId.substring(5,8);
			xAxArray.push(xAxObj);
			break;
		}
		else
		{
			//push next���ߵ���˸߶� xAx���� -- 2016.7.19.lsd
			Data_Line_b.push([xAx, parseFloat(nextGX_Base_Height) + parseFloat(tmpGX.Diameter)]);
			Data_Line_d.push([xAx, parseFloat(nextGX_Base_Height)]);
			//��֯��ǩ���ݣ�񿾮ID��
			var xAxObj = new Object();
			xAxObj.xAx = xAx;
			xAxObj.tId = tmpGJ.tId.substring(5,8);
			xAxArray.push(xAxObj);
			
			//��֯X�����꣨���ݹ��߳����ۼӣ�
			xAx += parseFloat(tmpGX.Length);
		}
		//��ȡEnd_Height
		preGX_Base_Height = tmpGX.End_Height;
		preGX_Diameter = tmpGX.Diameter;
		//��ȡ��һ��ѭ���Ĺܾ�����
		tmpGJ = arrayGet(gjArray, "tId", tmpGX.End_Id)[0];
	}//while
				/**********����b&����c&����d
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
        // ������������������ö������� lang ��
        lang: {
            resetZoom: '����',
            resetZoomTitle: '�������ű���'
        }
    });
    $('#container').highcharts({
        chart: {
        		zoomType: 'x',
            selectionMarkerFill: 'rgba(0,0,0, 0.2)',
            resetZoomButton: {
                // ��ť��λ
                position:{
                    align: 'right', // by default
                    verticalAlign: 'top', // by default
                    x: 0,
                    y: 0
                },
                // ��ť��ʽ
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
                text: '����(m)'
            }
        },
        yAxis: {
            min: min_Height,
            title: {
                text: '���(m)'
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
        	
        	//�رն���
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