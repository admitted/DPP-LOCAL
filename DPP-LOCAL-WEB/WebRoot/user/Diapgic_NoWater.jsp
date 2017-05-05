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
<script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/exporting.js"></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList    Project_Info   = (ArrayList)session.getAttribute("Project_Info_" + Sid);
	ArrayList    MoreDev_GX   = (ArrayList)session.getAttribute("MoreDev_GX_" + Sid);
	ArrayList    MoreDev_GJ   = (ArrayList)session.getAttribute("MoreDev_GJ_" + Sid);
	java.text.DecimalFormat   df   =new   java.text.DecimalFormat("#.00");  

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
<body  style=" background:#CADFFF">
<form name="Gj_File" action="File_GJ.do" method="post" target="mFrame" enctype="multipart/form-data">
  <div id="container" style="min-width:400px;min-height:400px"></div>
</form>
</body>
<script LANGUAGE="javascript">
var xAx_Cat = new Array();
var dataArea = new Array();
<%
 		if(null != MoreDev_GJ)
 		{
			Iterator iter = MoreDev_GJ.iterator();
			while(iter.hasNext())
			{
				DevGJBean gjBean = (DevGJBean)iter.next();
				
				String gjId = gjBean.getId();
				String gjFlag = gjBean.getFlag();
				String gjBase_Height = gjBean.getBase_Height();
				String gjTop_Height = gjBean.getTop_Height();
				String gjCurr_Data = gjBean.getCurr_Data();
				
				String gxBase_Height = "0";
				String gxDiameter = "0";
				String gxLength = "0";
%>
				xAx_Cat.push('<%=gjId%>');
<%
				if(null != MoreDev_GX)
				{
		 			Iterator it = MoreDev_GX.iterator();
		 			while(it.hasNext())
					{
						DevGXBean gxBean = (DevGXBean)it.next();
						String tmpGJId = "";
						
						if(gjFlag.equals("2"))	//终点管井
						{
							tmpGJId = gxBean.getEnd_Id();
						}
						else
						{
							tmpGJId = gxBean.getStart_Id();
						}							
							
						if(tmpGJId.contains(gjId))
						{			
							gxDiameter = gxBean.getDiameter();
							gxLength = gxBean.getLength();
							if(gjFlag.equals("2"))	//终点管井
							{
								gxBase_Height = gxBean.getEnd_Height();
							}
							else
							{
								gxBase_Height = gxBean.getStart_Height();
							}							
								
							/**********数据b&数据c&数据d
							Data_GX_Top 	+= df.format(Float.parseFloat(gxBaseHeight)+Float.parseFloat(gxBean.getDiameter()))+",";									
							Data_WaterLev += df.format(Float.parseFloat(gjBaseHeight)+Float.parseFloat(gjBean.getCurr_Data()))+",";		
							Data_GX_Base 	+= gxBaseHeight +",";
							***********/
						}
	   			} 		
				}
				
				Data_Line_a += gjTop_Height + ","; 
				Data_Line_b += df.format(Float.parseFloat(gxBase_Height)+Float.parseFloat(gxDiameter))+",";	
				Data_Line_c += df.format(Float.parseFloat(gjBase_Height)+Float.parseFloat(gjCurr_Data))+",";
				Data_Line_d += gxBase_Height +",";
				
				Data_Bar_A += df.format(Float.parseFloat(gjTop_Height)-Float.parseFloat(gjBase_Height))+",";
				Data_Bar_C += gjCurr_Data+",";	
				Data_Bar_E += gjBase_Height +",";
				
				Data_Area_A += "[" + gxBase_Height + ", " + df.format(Float.parseFloat(gjBase_Height)+Float.parseFloat(gjCurr_Data)) + "], ";
				
 			}
 		} 	
 	%>
$(function () {

    $('#container').highcharts({
        chart: {
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },
        xAxis: {
            categories: xAx_Cat
        },
        yAxis: {
            min: 0,
            title: {
                text: '海拔(m)'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.x +'</b><br/>';
            }
        },
        plotOptions: {
            column: {
            		pointPadding: 0,
       					borderWidth: 0,
        				pointWidth: 20,
                stacking: 'normal',
                dataLabels: {
                    enabled: false
                },                
								tooltip:{
									headerFormat:false
								}
            }
        },
        series: [{
        	  type: 'column',
            name: '',
            color: 'gray',
            data: [<%=Data_Bar_A%>],
        }, {
        		type: 'column',
            name: '',
            color: 'white',
            data: [<%=Data_Bar_E%>],     
        }, {
          	type:'line',
          	color:'black',
            name: '',
            dashStyle: 'longdash',
            data: [<%=Data_Line_a%>],
            marker: {                                                     
            	enabled:false
            }
        }, {
          	type:'line',
          	color:'black',
            name: '',
            dashStyle: 'Solid',
            data: [<%=Data_Line_b%>],
            marker: {                                                     
            	enabled:false
            } 
        }, {
          	type:'line',
          	color:'black',
            name: '',
            dashStyle: 'Solid',
            data: [<%=Data_Line_d%>],
            marker: {                                                     
            	enabled:false
            }
        }]
    });
});
</script>
</html>