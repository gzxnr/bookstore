<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page language="java" import="java.util.*" %>
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
    String isbnname = request.getParameter("isbn");
	int flag = 0;
	String _username = "";
	int _userid = -1;
	if (!(session.getAttribute("user") != null
			|| session.getAttribute("admin") != null)) {
		response.sendRedirect("login.jsp");
	} else if (session.getAttribute("user") != null) {
		flag = 1;
		_username =session.getAttribute("username").toString();
		_userid = Integer.parseInt(session.getAttribute("userid").toString());
		System.out.println(_userid);
	}
%> 
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js">

</script>
</head>
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

<h3 class="text-center">图书详情</h3>
<br/>

<table id="detailtable" class="table table-hover">
<tr class="active">
  <td rowspan="8"></td>
  <td>ISBN</td>
  <td ></td>
</tr>
<tr class="warning">
  <td>书名</td>
  <td ></td>
</tr>
<tr class="success">
  <td>豆瓣评分</td>
  <td ></td>
</tr>
<tr class="warning">
  <td>作者</td>
  <td ></td>
</tr>
<tr class="danger">
  <td>出版社</td>
  <td ></td>
</tr>
<tr class="info">
  <td>原价</td>
  <td ></td>
</tr>
<tr class="info">
  <td>折扣</td>
  <td ></td>
</tr>
<tr class="danger">
  <td>库存</td>
  <td ></td>
</tr>
<tr class="warning">
  <td colspan ="3"></td>
</tr>
</table>
<center>
<form role="form" class="form-search" action="<%=basePath %>addtocart.do">
<div class="form-group" id="umanage" style="display:none">
<label for="buynum">购买数量：</label>
<input type="hidden" id="price" name="price" value="">
<input type="hidden" id="isbn" name="isbn" value="">
<input type="hidden" id="userid" name="userid" value="<%=_userid %>">
<input type="text" id="buynum" name="buynum" value="">   
<button id="button_1" type="submit" class="btn btn-primary btn-lg active" onclick="verify()">加入购物车</button>
</div>
</form>

<div  id="amanage1" style="display:none">
<label for="remain">库存：</label>
<input type="text" id="remain" name="remain"> 
<button id="button_2" type="submit" class="btn btn-default" onclick="updateremain()">更新</button>
</div>

<br>
<div  id="amanage2" style="display:none">
<label for="discount">折扣：</label>
<input type="text" id="discount" name="discount"> 
<button id="button_3" type="submit" class="btn btn-default" onclick="updatediscount()">更新</button>
</div><br>
<div class="container" id="businessEname_div">
    <div class="row"> 
        <div class="span1"></div> 
      <div class="span10">
         
         
         <div class="widget-box">
        <div class="widget-content nopadding">
          <table class="table table-bordered table-striped table-hover data-table"> 
            <thead>
              <tr> 
                <th>评论</th>  
                <th>用户</th>
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
  <br>
  
<center><input id="button_5" type="button" style="display:none" class="btn btn-default" onclick="advice()"></center>
<br>
<input id="adviceflag" name="adviceflag" type="hidden">
  <div  id="addcomment" style="display:none">
<textarea type="text" id="comment" name="comment"></textarea>
<button id="button_4" type="submit" class="btn btn-default" onclick="addcomments()">添加评论</button>
</div>
</center>
<input type="hidden" id="username" name="username" value=<%=_username %>>

</body>

<script type="text/javascript">
	window.onload=function(){
		if(<%=flag%> == 0){
		     $("#adminbar").show();
		     $("#amanage1").show();
		     $("#amanage2").show();
		     $("#button_5").show();
			}else if(<%=flag%> == 1){
				//$("#button_5").invisible();
				$("#userbar").show();
				$("#umanage").show();
				$("#addcomment").show();
				}

/* 	var url = document.location.toString();
	var arrUrl = url.split("?");
	var para = arrUrl[1];
	var _isbn = para; */
	var _isbn = ${param.isbn};
	
		   $.ajax({  
			    type: "POST",      
		   		url: "<%=basePath%>bookinfo.do?isbn="+_isbn,
		   		dataType: "json",   /*这句可用可不用，没有影响*/  
		   		contentType: "application/json; charset=utf-8",
			    success:function(data) {
			    	var _discount = "";
			    	if(data.discount !=""){
			    		_discount = "<font color='red'>"+data.discount + "折</font>"
			    	}else{
			    		_discount = "无";
			    	}
			    	$('#detailtable')[0].rows[0].cells[0].innerHTML="<center><img alt='' src='upload/"+data.pic+"' style='width:200px;height:250px;background-color: none;border: none;'></center>";
			    	$('#detailtable')[0].rows[0].cells[2].innerHTML=data.isbn;
			    	$('#detailtable')[0].rows[1].cells[1].innerHTML=data.bookname;
			    	$('#detailtable')[0].rows[3].cells[1].innerHTML=data.author;
			    	$('#detailtable')[0].rows[4].cells[1].innerHTML=data.press;
			    	$('#detailtable')[0].rows[5].cells[1].innerHTML=data.price;
			    	$('#detailtable')[0].rows[6].cells[1].innerHTML=_discount;
			    	$('#detailtable')[0].rows[7].cells[1].innerHTML=data.remain;
			    	$('#detailtable')[0].rows[8].cells[0].innerHTML=data.description;
			    	$('#price')[0].value = data.price;
			    	$('#isbn')[0].value = data.isbn;
			    	$('#adviceflag').val(data.advice);
			    	if(data.advice == 1){
			    		$("#button_5").attr("value","撤销推荐");
			    	}else{
			    		$("#button_5").attr("value","推荐");
			    	}

				},
		    	error: function() {
	       		
		    	} 
		   });

			$.getJSON("https://api.douban.com/v2/book/isbn/"+_isbn+"?alt=xd&callback=?", function(book){
			    var rate = book.rating.average;
			    $('#detailtable')[0].rows[2].cells[1].innerHTML= rate;
			   
			});  
		     $("#tby tr").remove();   
		     $.ajax({  
		  	       
		     		type: "post",        
		     		url: "<%=basePath%>getcomments.do?isbn="+_isbn,       
		     		dataType: "json",   /*这句可用可不用，没有影响*/  
		     		contentType: "application/json; charset=utf-8",      
		     		success: function (data) {        
		     			var tby=$("#tby");    
		     			//循环json中的数据 
		     			$.each(data.commentslist, function(i, item) {  
		     				var td1 =$("<td>"+item.comment+"</td>");  
		     				var td2 =$("<td><center>"+item.username+"<center></td>");   
		     				var tr=$("<tr></tr>"); 
		     				tr.append(td1).append(td2);
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
function updateremain(){
	var _isbn = ${param.isbn};
	var _remain = $("#remain").val();
	$.ajax({
	    async: false,
	    type: "POST",
	    cache: false, 
		url:"<%=basePath%>updateremain.do?isbn="+ _isbn +"&remain="+ _remain,
		success:function(){
			$('#detailtable')[0].rows[7].cells[1].innerHTML=_remain;
			
		},
		error:function(){
			
		}
	});
}

function advice(){
	var _isbn = ${param.isbn};
	var flag = $("#adviceflag").val();
	if(flag == 1){
		flag = 0;
	}else{
		flag = 1;
		
	}
	$.ajax({
	    async: false,
	    type: "POST",
	    cache: false, 
		url:"<%=basePath%>updateadvice.do?isbn="+ _isbn +"&flag="+ flag,
		success:function(){
			$("#adviceflag").val(flag);
			if(flag ==1){
				$("#button_5").attr("value","撤销推荐");
			}else{
				$("#button_5").attr("value","推荐");
			}
		},
		error:function(){
			
		}
	});
}

function updatediscount(){
	var _isbn = ${param.isbn};
	var _discount = $("#discount").val();
	$.ajax({
	    async: false,
	    type: "POST",
	    cache: false, 
		url:"<%=basePath%>updatediscount.do?isbn="+ _isbn +"&discount="+ _discount,
		success:function(){
			$('#detailtable')[0].rows[6].cells[1].innerHTML="<font color='red'>"+ _discount + "折</font>"
			
		},
		error:function(){
			
		}
	});
}
function addcomments(){
	var _isbn = ${param.isbn};
	var _username = $("#username").val();
	var _comment = $("#comment").val();
    var param={
        	isbn:_isbn,
        	comments:$("#comment").val(),
        	userid:$("#userid").val(),
    	    };
	$.ajax({
	    data: param,
	    async: false,
	    type: "POST",
	    cache: false,
		url:"<%=basePath%>addcomment.do",
		success:function(){
			var tby=$("#tby"); 
			var td1 =$("<td>"+_comment+"</td>");  
			var td2 =$("<td><center>"+_username+"<center></td>");   
			var tr=$("<tr></tr>"); 
			tr.append(td1).append(td2);
			tr.appendTo(tby);
		},
		error:function(){
			
		}
	});

	

}

function verify(){

	
}

</script>
</html>