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

<h3 class="text-center">搜索图书</h3>
<br/>
<center>
<form role="form" class="form-horizontal">
<div class="form-group">
<label for="isbn">ISBN</label>
<input type="text" id="isbn" name="isbn" value="">
</div>
<div class="form-group">
<label for="bookname">书名</label>
<input type="text" id="bookname" name="bookname" value="">
</div>

<div class="form-group">
<label for="bookname">作者</label>
<input type="text" id="author" name="author" value="">
</div>
<div class="form-group">
<label for="bookname">出版社</label>
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
</form>

<button id="button" type="submit" class="btn btn-primary btn-lg active" onclick="queryByPage(1)">搜索</button>
</center>
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
   
  /**
  * V1.0
  */  
  	window.onload=function(){
		if(<%=flag%> == 0){
		     $("#adminbar").show();
			}else if(<%=flag%> == 1){
				$("#userbar").show();
				}
  	  	}
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
 function queryByPage(currentPage){
     var numPerPage=5; //每页显示条数
     var _isbn =escape(encodeURIComponent($("#isbn").val()));
     var _bookname = escape(encodeURIComponent($("#bookname").val()));
     var _type = escape(encodeURIComponent($("#type").val()));
     var _author = escape(encodeURIComponent($("#author").val()));
     var _press = escape(encodeURIComponent($("#press").val()));
     $("#businessEname_div").show();
   $("#tby tr").remove();   
/*    var param={	    	
	    	ISBN:$("input[name='isbn']").val(),
	    	bookName:$("input[name='bookname']").val(),
	    	author:$("textarea[name='author']").val(),
	    	press:$("textarea[name='publish']").val(),
	    	type:$("textarea[name='type']").val(),
		    };  */  
   $.ajax({  
	       
   		type: "post",        
   		url: "<%=basePath%>searcher.do?Page="+currentPage+"&numPerPage="+numPerPage+"&isbn="+_isbn+"&bookname="+_bookname+"&author="+_author+"&press="+_press+"&type="+_type,       
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
