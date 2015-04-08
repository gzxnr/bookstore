package com.gzxnr.web.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.gzxnr.bean.UserBean;
import com.gzxnr.dao.UserDao;

@Controller
@RequestMapping("/register.do")
public class RegisterController extends BaseController{
	@Autowired
	private UserDao _userDao;
	@RequestMapping(params = "method=register")
	public Object register(HttpServletRequest request, HttpServletResponse response, UserBean user) throws IOException{
		if(_userDao.createNewUser(user) != -1){
			request.getSession().setAttribute("info", "注册成功请登录");
			//return new ModelAndView("redirect:login.do");
			return user;
			
		}else{
			request.getSession().setAttribute("info", "用户名已存在，注册失败");
			return "register";
		}
		
	}
}
