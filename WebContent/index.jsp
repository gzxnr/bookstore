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
if(session.getAttribute("user")!=null){
	response.sendRedirect("searcher.jsp");
}
%>
<html>
<head>
<meta content="text/html;charset=UTF-8">
<title>书店</title>
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js">

</script>

</head>


<br/>
<br/>
<br/>
<br/>
<h1 class="text-center">书  店</h1>
<br/>
<br/>
<center>
<form action="login.jsp">
<button type="submit" class="btn btn-default">用户登录</button>
</form>
<form action="register.jsp">
<button type="submit" class="btn btn-default">用户注册</button>
</form>
<form action="adminlogin.jsp">
<button type="submit" class="btn btn-default">管理员登录</button>
</form>
</center>
</div>

</body>
</html>