package com.gzxnr.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gzxnr.bean.AdminBean;
import com.gzxnr.bean.UserBean;
import com.gzxnr.dao.AdminDao;
import com.gzxnr.dao.CartDao;
import com.gzxnr.dao.UserDao;

@Controller

public class LoginController extends BaseController{
	@Autowired
	private UserDao _userDao;
	@Autowired
	private CartDao _cartDao;
	@RequestMapping("/login.do")	
	public Object Login(HttpServletRequest request,UserBean _userBean){
		UserBean user = _userDao.findUserByNamePw(_userBean.getUserName(), _userBean.getPassword());
		if (user != null) {
			int cartCount = _cartDao.countCart(user.getUserId());
			request.getSession().setAttribute("user",
					user);
			request.getSession().setAttribute("username",
					user.getUserName());
			request.getSession().setAttribute("cartcount",
					cartCount);
			System.out.println("用户ID："+user.getUserId() + " 购物车："+cartCount);
			request.getSession().setAttribute("userid",
					user.getUserId());
			request.getSession().setAttribute("admin",
					null);
			return ("redirect:/advicedbooks.jsp");
		}else{
			request.getSession().setAttribute("message", "用户名或密码错误！");
			return ("redirect:/login.jsp");
		}
	}
	@Autowired
	private AdminDao _adminDao;
	@RequestMapping("/adminlogin.do")	
	public Object AdminLogin(HttpServletRequest request,AdminBean _adminBean){
		AdminBean admin = _adminDao.findAdminByNamePw(_adminBean.getAdminName(), _adminBean.getPassword());
		if (admin != null) {
			request.getSession().setAttribute("admin",
					admin);
			request.getSession().setAttribute("user",
					null);
			
			return ("redirect:/advicedbooks.jsp");
		}else{
			request.getSession().setAttribute("message", "用户名或密码错误！");
			return ("redirect:/adminlogin.jsp");
		}
	}
	
	@RequestMapping("/logout.do")
	public String logout(HttpServletRequest request){
		request.getSession().invalidate();
		return ("redirect:/index.jsp");
	}
}
