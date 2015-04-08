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

function verify(){
	if($("#isbn").val()==''){
		alert("ISBN不得为空");
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
<h3 class="text-center">利用豆瓣API快速添加新书</h4>
<br/>


<form class="form-horizontal" role="form" action="<%=basePath %>addbooksbydouban.do">
<center> 
<div class="form-group">
<label for="isbn">ISBN</label>
<div class="col-sm-10">
<input type="text" id="isbn" name="isbn" value="">
</div>
</div>

<div class="form-group">
<label for="remain">库存</label>
<input type="text" id="remain" name="remain" value="">
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
<br>
<button id="button" class="btn btn-primary btn-lg active" onclick="verify()">一键添加</button>
</form>
<center>

</div>
</body>
</html>