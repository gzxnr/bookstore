package com.gzxnr.web.controller;

import javax.servlet.http.HttpServletRequest;


public class BaseController {
	public String[] getContextPaths(HttpServletRequest request){
		String[] str=new String[2];
		String basePath = request.getScheme() + "://"
		+ request.getServerName() + ":" + request.getServerPort()
		+ request.getContextPath() + "/";
		String realPath=request.getSession().getServletContext().getRealPath("/");
		str[0]=basePath;//0为URL路径：……localhost:8080/rctp/
		str[1]=realPath;//e:\……\rctp\
		//System.out.println(PrintHelpler.getPosition()+"basePath is:"+basePath);
		//System.out.println(PrintHelpler.getPosition()+"realPath is:"+realPath);
		return str;
	}
}
