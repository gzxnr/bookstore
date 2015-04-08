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
if(session.getAttribute("admin")==null){
	response.sendRedirect("adminlogin.jsp");
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
<div><div class="navbar">
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

<p class="text-left"><h1 >书  店</h1></p>

<h3 class="text-center">我的订单</h3>

<br/>
</br>
<div class="container" id="businessEname_div" style="display:none">
    <div class="row"> 
        <div class="span1"></div> 
      <div class="span10">
         
         
         <div class="widget-box">
        <div class="widget-content nopadding">
          <table class="table table-bordered table-striped table-hover data-table"> 
            <thead>
              <tr> 
                <th>订单编号</th>  
               <th>用户</th>
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
   			  
        <div class="pagination">
            <input type="hidden" id="totalPage_input"/> 
          <ul>
            <li><a href="javascript:void(0);" id="firstPage">首页</a></li>
            <li><a href="javascript:void(0);" id="shang">上一页</a></li>
            <li><a href="javascript:void(0);" id="xia">下一页</a></li>
            <li><a href="javascript:void(0);" id="lastPage">末页</a></li>
            <li>共<lable id="totalPage"></lable>页</li>  
            <li>第<lable id="currentPage"></lable>页</li>  
            <li>共<lable id="totalRows"></lable>条记录</li>   
          </ul>
         </div>
      </div> 
        <div class="span1"></div>    
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
 
      window.onload=function(){
    	  queryByPage(1);
      }
 //分页查询 
 function queryByPage(currentPage){
     var numPerPage=10; //每页显示条数
     $("#businessEname_div").show();
   $("#tby tr").remove();  
   $.ajax({         
   		type: "post",        
   		url: "<%=basePath%>showallorderlist.do?Page="+currentPage+"&numPerPage=10",       
   		dataType: "json",   /*这句可用可不用，没有影响*/  
   		contentType: "application/json; charset=utf-8",      
   		success: function (data) {   
   			var tby=$("#tby"); 
   			var totalPage=data.totalPage;   
   			$("#totalPage_input").val(totalPage);   
   			$("#currentPage").html(data.Page);  
   			$("#totalRows").html(data.totalRows);  
   			$("#totalPage").html(totalPage);
   			//循环json中的数据 
   			$.each(data.orderlist, function(i, item) {  
   				//alert(item.userid);
   				var td1 =$("<td>"+item.orderid+"</td>"); 
   				var td2 =$("<td>"+item.userid+"</td>");
   			  	var td3 =$("<td>"+item.adddate+"</td>");
   			  	var td4 =$("<td>"+item.totalprice+"</td>");  
   				var td5 =$("<td>"+item.detail+"</td>");
   				var td6 =$("<td>"+item.address+"</td>");  
   				if(item.status == "发货"){
   					var newStatus = 1;
   					var td7 =$("<td id='statusname"+item.orderid+"'><a onclick='changeStatus("+item.orderid+","+newStatus+");'>"+item.status+"</a></td>");
   				}else{
   					var td7 =$("<td>"+item.status+"</td>");
   				}
   				var tr=$("<tr></tr>"); 
   				tr.append(td1).append(td2).append(td3).append(td4).append(td5).append(td6).append(td7);
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
		    	document.getElementById("statusname"+orderid).innerHTML= "已发货";
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