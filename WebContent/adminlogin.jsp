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
if(session.getAttribute("admin")!=null){
	response.sendRedirect("addbooks.jsp");
}
%>
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="<%=basePath %>css/jquery-1.6.1.js" type="text/javascript"></script>

<script type="text/javascript" >
function submitForm(){
	if($("#username").val()==''){
		alert("用户名不得为空");
		return false;
	}
	if($("#password").val()==''){
		alert("密码不得为空");
		return false;
	}
    var param={
        	password:$("input[name='password']").val(),
        	adminName:$("input[name='username']").val(),
    	    };
	$.ajax({
	    url: "<%=basePath%>adminlogin.do",
	    data: param,
	    async: false,
	    type: "POST",
	    cache: false,
	    success:function() {
		    	window.location.href='<%=basePath%>addbooks.jsp';
			},
	    error: function(e) {
          alert("ajax error");
	    }
	});
}
</script>
</head>


</br>
<p class="text-left"><h1 ><a href='<%=basePath %>index.jsp'>书  店</a></h1></p>

<h3 class="text-center">管理员登录</h3>
<center><div id="text-success">${ainfo }</div></center>
<br/>
<center>
<form role="form" class="form-horizontal">
<div class="form-group">
<label for="username">用户名</label>
<input type="text" id="username" name="username" value="">
</div>
<div class="form-group">
<label for="password">密码</label>
<input type="password" id="password" name="password" value="">
</div>
</form>
<center><button type="submit" class="btn btn-default" onclick="submitForm()">登录</button></center>
</br>

<tr>
<center><td class="warning">${message }</td></center>
</tr>

</center>
</body>
</html>