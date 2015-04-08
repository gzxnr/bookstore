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
	
    String _userid =""; 
	int flag = 0;
	String _username = "";
	String _cartcount = "";
	if (session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
	} else {
		flag = 1;
		_userid =session.getAttribute("userid").toString();
		_username =session.getAttribute("username").toString();
		_cartcount = session.getAttribute("cartcount").toString();
		System.out.println("页面取到的UID："+_userid);
	}
%> 
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>
<script src="<%=basePath%>css/bootstrap.min.js" type="text/javascript"></script>
</head>
<body>
<div><div class="navbar" id="userbar" > 
  <div class="navbar-inner">
    <a class="brand" href="#"><%=_username %></a>
    <ul class="nav">
    <li><a href="advicedbooks.jsp">推荐</a></li>
      <li><a href="searcher.jsp">搜索图书</a></li>
      <li><a href="mycart.jsp?userid=<%=_userid %>">我的购物车<span class="badge"><%=_cartcount %></span></a></li>
      <li><a href="order.jsp?userid=<%=_userid %>">我的订单</a></li>
      <li><a href="" onclick="javascript:logout()">退出登录</a><li>
    </ul>
  </div>
</div></div>

<!-- Nav tabs -->

<p class="text-left"><h1 >书  店</h1></p>

<h3 class="text-center">我的购物车</h3>
<center><lable>${buymessage }</lable></center>
<br/>
</br>
<div class="container" id="businessEname_div">
    <div class="row"> 
        <div class="span1"></div> 
      <div class="span10">
         
         
         <div class="widget-box">
        <div class="widget-content nopadding">
          <table class="table table-bordered" id="carttable" text-align:center> 
            <thead>
              <tr> 
               
                <th><center>书名</center></th>
                 
                <th><center>作者</center></th> 
                <th><center>出版社</center></th>  
                <th><center>售价</center></th> 
                <th><center>数量</center></th> 
                <th><center>操作</center></th> 
              </tr>  
            </thead>
            <tbody id="tby"> 
              
   						</tbody>
   					</table> 
   				</div>
   			  </div>
         
      </div> 
      </div>
      </div>
        <div><center><form action="<%=basePath %>gotobuy.do">
        <input type="hidden" value=<%=_userid %> id="userid" name="userid">
        <button id="button" type="submit" class="btn btn-primary btn-lg active" disabled="true">一键购买</button>
        
        
        </form> </center></div>  
  
  <script type="text/javascript">
   function deleteTr(nowTr,cartid){
	   $(nowTr).parent().parent().parent().remove();
	   $.ajax({
		   type:"post",
		   url:"<%=basePath%>deletecart.do?cartid=" + cartid,
		    async: false,
		    cache: false,      
	   		success: function () {  
	   			
	   		}	   
	   });
	   
   }
   window.onload=function(){
	   
   $.ajax({  
   		type: "post",        
   		url: "<%=basePath%>showcart.do?userid=<%=_userid%>",       
   		dataType: "json",   /*这句可用可不用，没有影响*/  
   		contentType: "application/json; charset=utf-8",      
   		success: function (data) {        
   			var tby=$("#tby");  
   			//循环json中的数据 
   			if(data.cartshowlist.length>0){
   				document.getElementById("button").disabled = false;
   	   			}
   			$.each(data.cartshowlist, function(i, item) { 
   	   			//alert("hi");
   	   			//var td1 =$("<td width='140px'><img alt='' src='upload/"+item.pic+"' style='width:135px;height:125px;background-color: none;border: none;'></td>");
   				var td2 =$("<td><center><a href='#' data-toggle=‘popover’ data-placement='left' data-toggle=‘popover’ title='"+item.description+"'>"+item.bookname+"</a></center></td>");  
   				//var td3 =$("<td>"+item.isbn+"</td>");
   				var td4 =$("<td><center>"+item.author+"</center></td>");  
   				var td5 =$("<td><center>"+item.press+"</center></td>");   
   				var td6 =$("<td><center>"+item.price+"</center></td>");
   				var td7 =$("<td><center>"+item.buynum+"</center></td>");
   				var td8 =$("<td><center> <a onclick='deleteTr(this,"+item.cartid+");'>删除</a></center></td>");
   				var tr=$("<tr></tr>"); 
   				tr.append(td2).append(td4).append(td5).append(td6).append(td7).append(td8);
   				tr.appendTo(tby);  
   				
   			}); 
   			
   		},      
   		error: function (XMLHttpRequest, textStatus, errorThrown) {     
   			alert("请求错误");     
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