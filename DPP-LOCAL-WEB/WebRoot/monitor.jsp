<%@ page contentType="text/html;charset=GBK"%>  
<%@ page import="java.util.*"%>  
<%  
    out.println("<br>");  
    out.println("<center><h1>");  
    out.println("The Web Server is Running!<br><br>");  
    out.println("</h1></center>");  
    out.println("<br><br>");  
    out.println("ServerStillWorking");//标记字符！  
  
    long maxMemory = Runtime.getRuntime().maxMemory() / 1024 / 1024; //java虚拟机能取得的最大内存  
    long totalMemory = Runtime.getRuntime().totalMemory() / 1024 / 1024; //java虚拟机当前取得的内存大小  
    long freeMemory = Runtime.getRuntime().freeMemory() / 1024 / 1024; //java虚拟机所占用的内存中的空闲部分  
    long usedMemory = totalMemory - freeMemory; //java虚拟机当前实际使用的内存大小  
    out.println("<br><br>Max Momery is: " + maxMemory + "M");  
    out.println("<br>Total Memory is: " + totalMemory + "M");  
    out.println("<br>Used Memory is: " + usedMemory + "M");  
    out.println("<br>Free Memory is: " + freeMemory + "M");  
    out.println("<br><br>");  
  
    if (usedMemory < maxMemory) {  
        out.println("LessOfMemory"); //标记字符!  
    } else {  
        out.println("OutOfMemory"); //标记字符!  
    }  
    out.println("<br><br>");  
    out.println(new java.util.Date());  
    out.println("<br>");  
    out.println(TimeZone.getDefault().getDisplayName());  
%>  
