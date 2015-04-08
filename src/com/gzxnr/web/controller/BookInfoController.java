package com.gzxnr.web.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gzxnr.bean.BookBean;
import com.gzxnr.bean.CartBean;
import com.gzxnr.bean.CommentBean;
import com.gzxnr.bean.UserBean;
import com.gzxnr.dao.BookDao;
import com.gzxnr.dao.CommentDao;
import com.gzxnr.dao.UserDao;

@Controller
public class BookInfoController extends BaseController{
	@Autowired
	BookDao _bookDao;
	@Autowired
	CommentDao _commentDao;
	@Autowired
	UserDao _userDao;
	@RequestMapping("/bookinfo.do")
	public void showBookInfo(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String isbn  = request.getParameter("isbn");
		System.out.println(isbn);
		PrintWriter out = null;
		out = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		BookBean book = _bookDao.getBookByISBN(isbn);
		
		map.put("isbn", book.getISBN());System.out.println(book.getISBN());
		map.put("bookname", book.getBookName());System.out.println(book.getBookName());
		map.put("author", book.getAuthor());System.out.println(book.getAuthor());
		map.put("press", book.getPress());System.out.println(book.getPress());
		map.put("price", book.getPrice());System.out.println(book.getPrice());
		map.put("remain", book.getRemain());System.out.println(book.getRemain());
		map.put("discount", book.getDiscount()==null?"":book.getDiscount());System.out.println(book.getDiscount());
		map.put("description", book.getDescription()==null?"":book.getDescription());System.out.println(book.getDescription());
		map.put("pic", book.getPicture()==null?"":book.getPicture());System.out.println(book.getPicture());
		map.put("advice", book.getAdvice());
		//map.put("description", book.getDescription()==null?"":book.getDescription());System.out.println(book.getDescription());
	    response.setContentType("text/html;charset=UTF-8");     
	    out.write(JSONSerializer.toJSON(map).toString());
	    out.flush();
	    out.close();
	}
	@RequestMapping("/updateremain.do")
	public void updateRemain(HttpServletRequest request,HttpServletResponse response){
		String isbn = request.getParameter("isbn");
		int remain = Integer.valueOf(request.getParameter("remain"));
		_bookDao.updateRemainByISBN(isbn, remain);
	}
	@RequestMapping("/updatediscount.do")
	public void updateDiscount(HttpServletRequest request,HttpServletResponse response){
		String isbn = request.getParameter("isbn");
		String discount = request.getParameter("discount");
		_bookDao.updateDiscountByISBN(isbn, discount);
	}
	@RequestMapping("/updateadvice.do")
	public void updateAdvice(HttpServletRequest request,HttpServletResponse response){
		String isbn = request.getParameter("isbn");
		int flag = Integer.parseInt(request.getParameter("flag"));
		_bookDao.updateAdviceByISBN(isbn, flag);
	}
	@RequestMapping("/getcomments.do")
	public void getComments(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String isbn = request.getParameter("isbn");
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> showlist = new ArrayList<Map<String, Object>>();
		List<CommentBean> commentsList = _commentDao.getBooksComments(isbn);
		if (commentsList != null) {
			for (CommentBean item : commentsList) {
				Map<String, Object> maps = new HashMap<String, Object>();
				UserBean user = _userDao.getUserByUserID(item.getUserid());
				maps.put("username", user.getUserName());
				maps.put("comment", item.getComments());System.out.println(item.getComments());
				showlist.add(maps);
			}
		}else{
			Map<String, Object> maps = new HashMap<String, Object>();
			maps.put("info", "error");
			showlist.add(maps);
		}
		map.put("message", "success");
		map.put("commentslist", showlist);
		System.out.println(map);
		JSONObject json = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
	}
	@RequestMapping("/addcomment.do")
	public void addComment(HttpServletRequest request, HttpServletResponse response, CommentBean _commentBean){
		_commentDao.addComment(_commentBean.getIsbn(), _commentBean.getUserid(), _commentBean.getComments());
	}
}
