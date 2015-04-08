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
	String _userid = "";
	int flag = 0;
	String _username = "";
	if (!(session.getAttribute("user") != null
	|| session.getAttribute("admin") != null)) {
		response.sendRedirect("login.jsp");
	} else if (session.getAttribute("user") != null) {
		flag=1;
		_userid = session.getAttribute("userid").toString();
		_username = session.getAttribute("username").toString();
		System.out.println("页面取到的UID：" + _userid);

	}
%> 
<%

%> 
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>
<script src="<%=basePath%>css/bootstrap.js" type="text/javascript"></script>
</head>
<body>
<div><div class="navbar" id="adminbar" style="display:none"> 
  <div class="navbar-inner">
    <a class="brand" href="#">管理</a>
    <ul class="nav">
      <li><a href="advicedbooks.jsp">推荐</a></li>
      <li><a href="searcher.jsp">搜索图书</a></li>
      <li><a href="addbooks.jsp">新增图书</a></li>
      <li><a href="quickaddbooks.jsp">快速新增图书</a></li>
      <li><a href="ordermanage.jsp">订单管理</a></li>
      <li><a href="" onclick="javascript:logout()">退出登录</a><li>
    </ul>
  </div>
</div></div>

<div><div class="navbar" id="userbar" style="display:none"> 
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

<h3 class="text-center">推荐</h3>
<br/>

<div class="container" id="businessEname_div" >
    <div class="row"> 
        <div class="span1"></div> 
      <div class="span10">
         
         
         <div class="widget-box">
        <div class="widget-content nopadding">
          <table class="table table-bordered table-striped table-hover data-table"> 
            <thead>
              <tr> 
                <th><center>封面<center></th>  
                <th><center>书名<center></th>
                <th><center>ISBN<center></th> 
                <th><center>作者<center></th> 
                <th><center>出版社<center></th>  
              </tr>  
            </thead>
            <tbody id="tby"> 
              
   						</tbody>
   					</table> 
   				</div>
   			  </div>
   			  
      </div> 
        <div class="span1"></div>    
    </div>
  </div>
  <script type="text/javascript">
   
  /**
  * V1.0
  */  
  	window.onload=function(){
		if(<%=flag%> == 0){
		     $("#adminbar").show();
			}else if(<%=flag%> == 1){
				$("#userbar").show();
				}
	  
   $("#tby tr").remove();   
   $.ajax({  
	       
   		type: "post",        
   		url: "<%=basePath%>advicedbooks.do",       
   		dataType: "json",   /*这句可用可不用，没有影响*/  
   		contentType: "application/json; charset=utf-8",      
   		success: function (data) {        
   			var tby=$("#tby");     
   			//循环json中的数据 
   			$.each(data.booklist, function(i, item) {  
   				var td1 =$("<td width='140px'> <img alt='' id='"+item.ISBN+"'src='upload/"+item.picture+"' style='width:135px;height:185px;background-color: none;border: none;'></td>");  
   				var td2 =$("<td><a href='<%=basePath %>bookinfo.jsp?isbn="+item.ISBN+"' data-container='body' data-toggle='popover' data-placement='left' title='"+item.description+"'><center>"+item.bookName+"<center></a></td>");
   				var td3 =$("<td>"+item.ISBN+"</td>");  
   				var td4 =$("<td><center>"+item.author+"<center></td>");   
   				var td5 =$("<td><center>"+item.press+"<center></td>");   
   				var tr=$("<tr></tr>"); 
   				tr.append(td1).append(td2).append(td3).append(td4).append(td5);
   				tr.appendTo(tby);
   			});  
   		},      
   		error: function (XMLHttpRequest, textStatus, errorThrown) {     
   		alert(errorThrown);     
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
