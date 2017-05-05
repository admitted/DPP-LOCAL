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
	ArrayList User_Graph_Curve = (ArrayList)session.getAttribute("User_Graph_Curve_" + Sid);
	DevGJBean User_DevGJ_Info = (DevGJBean)session.getAttribute("User_DevGJ_Info_" + Sid);
	
	String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
  String GJ_Id = request.getParameter("Id");
  String Curr_Data = "";
	String Material = "";
	String Base_Height = "";
	String Top_Height = "";
	String Equip_Height = "";
	
	if(User_DevGJ_Info != null)
  {
	  Curr_Data 	= User_DevGJ_Info.getCurr_Data();
		Material 		= User_DevGJ_Info.getMaterial();
		Base_Height = User_DevGJ_Info.getBase_Height();
		Top_Height 	= User_DevGJ_Info.getTop_Height();
		Equip_Height= User_DevGJ_Info.getEquip_Height();
  }

  if(User_Graph_Curve != null){
  	Iterator iterator = User_Graph_Curve.iterator();
		DataGJBean statBean = (DataGJBean)iterator.next();
		GJ_Id = statBean.getGJ_Id();
  }

	%>
</head>
<body >
<form name='User_Graph_Curve'   method='post' target='mFrame'>
<div>
	<table border=0 cellPadding=0 cellSpacing=0 bordercolor='#3491D6' borderColorDark='#ffffff' width='100%'>
			<tr height='30' valign='top'>
					<td width='85%' align='center'>
				      <!--<select name='cmd' style='width:90px;height:20px' onChange='doSelect()'>
				      	<option value='4' <%=(currStatus.getCmd() == 4 ?"SELECTED":"")%>>���24Сʱ</option>
				        <option value='5' <%=(currStatus.getCmd() == 5 ?"SELECTED":"")%>>���1��</option>
				        <option value='6' <%=(currStatus.getCmd() == 6 ?"SELECTED":"")%>>���1��</option>
				      
				      </select>-->
				      
						<input id='BDate' name='BDate' type='text' 
						style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
						<input type="button" value="��ѯ" onClick='doSubmit()' >
				  </td>	  
			</tr>
  </table>
  <div id='container' style="min-width:200px;min-height:265px"></div>

</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
	
	function doSubmit()
	{
		location = "User_Graph_Curve.do?Sid=<%=Sid%>&Cmd=7&GJ_Id=<%=GJ_Id%>"
							+ "&Func_Project_Id=<%=currStatus.getFunc_Project_Id()%>"
							+ "&BTime=" + User_Graph_Curve.BDate.value + " 00:00:00"
							+ "&ETime=" + User_Graph_Curve.BDate.value + " 23:59:59";
	}

		var data_serie = [];
		var data_xAxis = [];
		<%
		DecimalFormat df = new DecimalFormat("##.####");
		if(User_Graph_Curve != null)
		{
			Iterator iterator = User_Graph_Curve.iterator();
			while(iterator.hasNext())
			{
				DataGJBean statBean = (DataGJBean)iterator.next();
				String CTime = statBean.getCTime();
				String CValue = statBean.getValue();
		%>
		     //if(7 == User_Graph_Curve.cmd.value){
		    
		    var CValue = <%=CValue%>;
		    var Base_Height = <%=Base_Height%>;
		    var Top_Height = <%=Top_Height%>;
		    var Equip_Height = <%=Equip_Height%>;
		    var Value = (Top_Height - Equip_Height + CValue) + "";
		    if(Base_Height > Value)
		    {
		    	Base_Height = Value;
		    }
			 	data_serie.push(parseFloat(Value.substring(0,5)));
			 	data_xAxis.push('<%=CTime.substring(11,13)%>');
				/*}else{
				 		data_serie.push(parseFloat('<%=CValue%>'));
				 		data_xAxis.push('<%=CTime.substring(8,10)%>');
				}*/
		<%
      }
  	}
		%>


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
                }],
                min:Base_Height,
                max:Top_Height
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