<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page language="java"  pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page language="java" import="java.util.*"  %>
<%@ page import="com.gzxnr.bean.*" %>
<%@ page import="com.gzxnr.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
int flag = 0;
String _userid =request.getParameter("userid"); 
String _username = "";
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
} else {

	flag = 1;
	_username =session.getAttribute("username").toString();
	System.out.println("页面取到的UID："+_userid);
}
%>
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>
<script src="<%=basePath%>css/bootstrap.js" type="text/javascript"></script>
</head>
<div><div class="navbar" id="userbar" > 
  <div class="navbar-inner">
    <a class="brand" href="#"><%=_username %></a>
    <ul class="nav">
    <li><a href="advicedbooks.jsp">推荐</a></li>
      <li><a href="searcher.jsp">搜索图书</a></li>
      <li><a href="mycart.jsp?userid=<%=_userid %>">我的购物车</a></li>
      <li><a href="order.jsp?userid=<%=_userid %>">我的订单</a></li>
      <li><a href="" onclick="javascript:logout()">退出登录</a><li>
    </ul>
  </div>
</div></div>

<p class="text-left"><h1 >书  店</h1></p>

<h3 class="text-center">我的订单</h3>

<br/>
</br>
<div class="container" id="businessEname_div">
    <div class="row"> 
        <div class="span1"></div> 
      <div class="span10">
         
         
<!--          <div class="widget-box">
        <div class="widget-content nopadding"> -->
          <table  class="table table-bordered" width="1000"> 
            <thead>
              <tr> 
                <th>订单编号</th>  
                <th>下单时间</th>
                <th>总价</th> 
                <th>订单详情</th> 
                <th>邮寄地址</th>
                <th>订单状态</th>
              </tr>  
            </thead>
            <tbody id="tby"> 
              
   						</tbody>
   					</table> 
         
      </div> 
      </div>
      </div>
    
  
  <script type="text/javascript">
      //首页
      $("#firstPage").bind("click",function(){
    	  var currentPage=1;
    	  queryByPage(currentPage); 
      });   
      
      //上一页  
      $("#shang").click(function(){
    	var currentPage = parseInt($("#currentPage").html());
        if(currentPage==1){
          alert("已经到达第一页");
          return ;
        }else{         
          currentPage--; 
          queryByPage(currentPage); 
        }
      });
      
      //下一页  
      $("#xia").click(function(){ 
    	var currentPage = parseInt($("#currentPage").html());
        if(currentPage >= parseInt($("#totalPage_input").val()) ){
          alert("已经到达最后一页");
          return ;
        }else{ 
          
          currentPage++;
          queryByPage(currentPage); 
        }
      });
      
      //末页
      $("#lastPage").bind("click",function(){ 
    	  var currentPage;
    	  currentPage=$("#totalPage_input").val(); 
    	  queryByPage(currentPage);  
      });
 

 //分页查询  
   window.onload=function(){
     var numPerPage=5; //每页显示条数
     $("#businessEname_div").show();
   $("#tby tr").remove();    
   $.ajax({  
	       
   		type: "post",        
   		url: "<%=basePath%>showorderlist.do?userid=<%=_userid%>",       
   		dataType: "json",   /*这句可用可不用，没有影响*/  
   		contentType: "application/json; charset=utf-8",      
   		success: function (data) {        
   			var tby=$("#tby");   
   			//循环json中的数据 
   			$.each(data.ordershowlist, function(i, item) {  
   				var td1 =$("<td>"+item.orderid+"</td>");  
   				var td2 =$("<td>"+item.addtime+"</td>");
   				var td3 =$("<td>"+item.totalprice+"</td>");  
   				var td4 =$("<td>"+item.detail+"</td>");
   				var td5 =$("<td>"+item.address+"</td>");  
   				if(item.status == "确认收货"){
   					var newStatus = 2;
   					var td6 =$("<td id='statusname"+item.orderid+"'><a onclick='changeStatus("+item.orderid+","+newStatus+");'>"+item.status+"</a></td>");
   				}else{
   					var td6 =$("<td>"+item.status+"</td>");
   				}
   				var tr=$("<tr></tr>"); 
   				tr.append(td1).append(td2).append(td3).append(td4).append(td5).append(td6);
   				tr.appendTo(tby);  
   			});  
   		},      
   		error: function (XMLHttpRequest, textStatus, errorThrown) {     
   		alert(errorThrown);     
   		}     
  });    
 }  
   function changeStatus(orderid, newStatus){ 
	   $.ajax({  
		    async: false,
		    type: "POST",
		    cache: false,       
	   		url: "<%=basePath%>changeorderstatus.do?newstatus="+newStatus+"&orderid="+orderid,
		    success:function() {
		    	document.getElementById("statusname"+orderid).innerHTML= "已收货";
			},
	    	error: function() {
         		alert("退出失败");
	    	} 
	   }); 
 }
 function logout(){
	   $.ajax({  
		    async: false,
		    type: "POST",
		    cache: false,       
	   		url: "<%=basePath%>logout.do",
		    success:function() {
		    	window.location.href='<%=basePath%>index.jsp';
			},
	    	error: function() {
          		alert("退出失败");
	    	} 
	   }); 
	 }
  
  </script> 
</body>
</html>