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
if(session.getAttribute("user")!=null){
	response.sendRedirect("searcher.jsp");
}
%>
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>
<script src="<%=basePath%>css/bootstrap.min.js" type="text/javascript"></script>
<script type="text/javascript" >
function submitForm(){
    var param={
    	method:'register',
    	userName:$("input[name='username']").val(),
    	password:$("input[name='password']").val(),
    	postCode:$("input[name='postcode']").val(),
    	phoneNum:$("input[name='phonenum']").val(),
    	address:$("textarea[name='address']").val(),
	    };
	if(verify()){
		$.ajax({
		    url: "<%=basePath%>register.do",
		    data: param,
		    async: false,
		    type: "POST",
		    cache: false,
		    success:function() {
			    	window.location.href='<%=basePath%>login.jsp';
				},
		    error: function(e) {
	          alert("ajax error");
		    }
		});
	    
	}
}

function verify(){
	if($("#username").val()==''){
		alert("用户名不得为空");
		return false;
	}
	if($("#password").val()==''){
		alert("密码不得为空");
		return false;
	}
	if($("#postcode").val()==''){
		alert("电话不得为空");
		return false;
	}
	if($("#phonenum").val()==''){
		alert("邮编不得为空");
		return false;
	}
	if($("#address").val()==''){
		alert("邮寄地址不得为空");
		return false;
	}
	return true;
}
</script>
</head>

<div id="updateview">
<form method="post" onsubmit="return submitForm();" >
<br/>
<p class="text-left"><h1 ><a href='<%=basePath %>index.jsp'>书  店</a></h1></p>
<h3 class="text-center">用户注册</h4>
<br/>
<center>

<form role="form" class="form-search">
<div class="form-group">
<label for="username">用户名</label>
<input type="text" id="username" name="username" value="">
</div>
<div class="form-group">
<label for="password">密码</label>
<input type="password" id="password" name="password" value="">
</div>
<div class="form-group">
<label for="phonenum">电话</label>
<input type="text" id="phonenum" name="phonenum" value="">
</div>
<div class="form-group">
<label for="postcode">邮编</label>
<input type="text" id="postcode" name="postcode" value="">
</div>
<div class="form-group">
<label for="address">邮寄地址</label>
<textarea  type="address" class="form-control" rows="3" id="address" name="address" value=""></textarea>
</div>
</form>
</center>
<br/>
<center> <button id="button" type="submit" class="btn btn-default" onclick="submitForm()">注册</button></center>
<center>${info }</center>

</center>
</form>
</div>
</body>
</html>