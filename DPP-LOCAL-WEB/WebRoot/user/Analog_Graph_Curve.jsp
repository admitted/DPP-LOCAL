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
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String Analog_Graph_Curve = (String)session.getAttribute("Analog_Graph_Curve_" + Sid);
  String GJ_Id = CommUtil.StrToGB2312(request.getParameter("GJ_Id"));
  String Curr_Data = "";
	String Material = "";
	String Base_Height = "";
	String Top_Height = "";

  /*if(Analog_Graph_Curve != null){
  	Iterator iterator = Analog_Graph_Curve.iterator();
		DataGJBean statBean = (DataGJBean)iterator.next();
		GJ_Id = statBean.getGJ_Id();
  }*/

	%>
</head>
<body >
<form name='User_Graph_Curve'   method='post' target='mFrame'>
	<div id='container' style="min-width:200px;min-height:290px"></div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doSelect()
{
	location = "User_Graph_Curve.do?Sid=<%=Sid%>&Cmd="
						+ User_Graph_Curve.cmd.value
						+ "&GJ_Id=<%=GJ_Id%>"
						+ "&Func_Project_Id=<%=currStatus.getFunc_Project_Id()%>";
}	


		var GJ_Id = '<%=GJ_Id%>';
		var data_serie = [];
		var data_xAxis = [];
		var Analog_Graph_Curve = "<%=Analog_Graph_Curve%>";
		var WaterLev;
		if(Analog_Graph_Curve != null && Analog_Graph_Curve.length > 0)
		{
			WaterLev = Analog_Graph_Curve.split("|");
			if(GJ_Id.substring(0,2) == "YJ")
			{
				data_serie = [];
				data_xAxis = [];
				for(var i = 1; i < WaterLev.length; i += 2)
				{
					data_serie.push(parseFloat(WaterLev[i]));
					data_xAxis.push(i);
				}
			}else
			{
				data_serie = [];
				data_xAxis = [];
				for(var i = 0; i < WaterLev.length-1; i ++)
				{
					data_serie.push(parseFloat(WaterLev[i]));
					data_xAxis.push(i);
				}
			}
		}
		
		var chart;
    $(document).ready(function () {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                defaultSeriesType: 'line',
                marginRight: 60,
                marginBottom: 25
            },
            title: {
                text: '',
                x: -20
            },
            subtitle: {
                text: '',
                x: -20
            },

            xAxis: {
                categories: data_xAxis  //����x��Ŀ̶�
                
            },
            yAxis: {
                title: {
                    text: '��λ/m'      //����y��ı���
                },
                plotLines: [{
                    value: 0,
                    width: 0.5,
                    color: '#808080'
                }]
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.series.name + '</b><br/>' +
               this.x + ': ' + this.y ;  //���������ݵ����ʾ��Ϣ�����ǵ�������ʾ��ÿ���ڵ���������ֵʱ�Ͳ������������ʾ��Ϣ
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: 0,
                y: 100,
                borderWidth: 0
            },
            exporting: {
                enabled: true,
                url: "http://localhost:49394/highcharts_export.aspx" //����ͼƬ��URL��Ĭ�ϵ�������Ҫ�����ٷ���վȥ��Ŷ
            },
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: true //��ʾÿ������ÿ���ڵ���������ֵ
                    },
                    enableMouseTracking: false
                }
            },
            series: [{
                name: 'ˮλ',
                data: data_serie
            }]
        });

    });

</script>
</html>