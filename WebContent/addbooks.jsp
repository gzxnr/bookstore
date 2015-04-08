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
<script type="text/javascript" >

function submitForm(){
	
    var param={
    	ISBN:$("input[name='isbn']").val(),
    	bookName:$("input[name='bookname']").val(),
    	author:$("input[name='author']").val(),
    	press:$("input[name='press']").val(),
    	type:$("select[name='type']").val(),
    	price:parseFloat($("input[name='price']").val()),
    	remain:parseInt($("input[name='remain']").val()),
    	picture:$("input[name='pic']").val(),
    	description:$("textarea[name='description']").val(),
	    };
	if(verify()){
		$.ajax({
		    url: "<%=basePath%>addbooks.do",
		    data: param,
		    async: false,
		    type: "POST",
		    cache: false,
		    success:function() {
			    alert("添加成功")
		    	document.getElementById("upload").disabled =false;
			    document.getElementById("_isbn").value =$("input[name='isbn']").val();
				},
		    error: function(e) {
	          alert("添加失败");
		    }
		});
	    
	}
}

function verify(){
	if($("#bookname").val()==''){
		alert("书名不得为空");
		return false;
	}
	if($("#isbn").val()==''){
		alert("ISBN不得为空");
		return false;
	}
	if($("#author").val()==''){
		alert("作者不得为空");
		return false;
	}
	if($("#press").val()==''){
		alert("出版社不得为空");
		return false;
	}
	if($("#price").val()==''){
		alert("售价不得为空");
		return false;
	}
	if($("#remain").val()==''){
		alert("库存不得为空");
		return false;
	}
	return true;
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
<h3 class="text-center">添加新书</h4>
<br/>


<form class="form-horizontal" role="form">
<center> 
<div class="form-group">
<label for="isbn">ISBN</label>
<div class="col-sm-10">
<input type="text" id="isbn" name="isbn" value="">
</div>
</div>
<div class="form-group">
<label for="bookname">书名</label>
<input type="text" id="bookname" name="bookname" value="">
</div>
<div class="form-group">
<label for="author">作者</label>
<input type="text" id="author" name="author" value="">
</div>
<div class="form-group">
<label for="press">出版社</label>
<input type="text" id="press" name="press" value="">
</div>
<div class="form-group">
<label for="bookname">种类</label>
<select type="text" id="type" name="type" value="">
<option value ="">请选择</option>
<option value ="科幻">科幻</option>
  <option value ="青春">青春</option>
  <option value="科技">科技</option>
  <option value="文学">文学</option></select>
</div>
<div class="form-group">
<label for="price">售价</label>
<input type="text" id="price" name="price" value="">
</div>
<div class="form-group">
<label for="remain">库存</label>
<input type="text" id="remain" name="remain" value="">
</div>
<div class="form-group">
<label for="description">简介</label>
<textarea  class="form-control" rows="4" id="description" name="description" value=""></textarea>
</div>
</form></center>
<center> <button id="button" class="btn btn-primary btn-lg active" onclick="submitForm()">添加</button></center>
<center>
<br>
<center>
<form action="<%=basePath %>upload.do" id="pic_form" name="pic_form" 
          enctype="multipart/form-data" method="post" >
          <center>
<input type="file" id="pic" name="pic" ></center>
<br>
<input name="_isbn" type="hidden" id="_isbn" value="" >
<input type="submit" name="upload" class="btn btn-primary btn-lg active" id="upload" value="上传封面" disabled=true></center>

</form>
</center>
</div>
</body>
</html>