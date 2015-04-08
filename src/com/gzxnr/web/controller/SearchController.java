package com.gzxnr.web.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gzxnr.bean.BookBean;
import com.gzxnr.dao.BookDao;
import com.gzxnr.service.SearchService;
import com.gzxnr.util.Pagination;

@Controller
public class SearchController extends BaseController {
	@Resource
	private SearchService ss;
	@Autowired
	BookDao _bookDao;

	@RequestMapping("/advicedbooks.do")
	public void advicedBooks(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		PrintWriter out = null;
		List<Map<String, Object>> booklist = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		out = response.getWriter();
		List<BookBean> list = _bookDao.getAdvicedBooks();
		for (BookBean item: list) {
			Map<String, Object> maps = new HashMap<String, Object>();
			maps.put("picture", item.getPicture());
			maps.put("ISBN", item.getISBN());
			maps.put("bookName", item.getBookName());
			maps.put("author", item.getAuthor());
			maps.put("press", item.getPress());
			maps.put("type", item.getType());
			maps.put("price", item.getPrice());
			maps.put("remain", item.getRemain());
			maps.put("description", item.getDescription());
			booklist.add(maps);
		}
		
		map.put("booklist", booklist);
		System.out.println(map);
		response.setContentType("text/html;charset=UTF-8");
		out.write(JSONSerializer.toJSON(map).toString());
		out.flush();
		out.close();
	}

	@RequestMapping("/searcher.do")
	public void queryBooks(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String message = "";
		String status = "";
		PrintWriter out = null;
		Pagination page = null;

		List<Map<String, Object>> booklist = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			out = response.getWriter();
			String currentPage = java.net.URLDecoder.decode(
					request.getParameter("Page"), "UTF-8");
			String numPerPage = java.net.URLDecoder.decode(
					request.getParameter("numPerPage"), "UTF-8");
			String ISBN = java.net.URLDecoder.decode(
					request.getParameter("isbn"), "UTF-8");
			String bookname = java.net.URLDecoder.decode(
					request.getParameter("bookname"), "UTF-8");
			String author = java.net.URLDecoder.decode(
					request.getParameter("author"), "UTF-8");
			String press = java.net.URLDecoder.decode(
					request.getParameter("press"), "UTF-8");
			String type = java.net.URLDecoder.decode(
					request.getParameter("type"), "UTF-8");

			if ("".equals(currentPage) || "".equals(numPerPage)) {
				page = ss.queryBooksBusiness(1, 10, ISBN, bookname, author,
						press, type);
			} else {
				page = ss.queryBooksBusiness(Integer.parseInt(currentPage),
						Integer.parseInt(numPerPage), ISBN, bookname, author,
						press, type);
			}
			List list = page.getResultList();
			System.out.println("结果集记录数：" + list.size());
			int len = list.size();
			for (int i = 0; i < len; i++) {
				Map<String, Object> maps = new HashMap<String, Object>();
				Map mapRe = (Map) list.get(i);
				maps.put("picture", mapRe.get("picture"));
				System.out.println(mapRe.get("picture"));
				maps.put("ISBN", mapRe.get("ISBN"));
				System.out.println(mapRe.get("isbn"));
				maps.put("bookName", mapRe.get("book_name"));
				System.out.println(mapRe.get("book_name"));
				maps.put("author", mapRe.get("author"));
				System.out.println(mapRe.get("author"));
				maps.put("press", mapRe.get("press"));
				System.out.println(mapRe.get("press"));
				maps.put("type", mapRe.get("type"));
				System.out.println(mapRe.get("type"));
				maps.put("price", mapRe.get("price"));
				System.out.println(mapRe.get("price"));
				maps.put("remain", mapRe.get("remain"));
				System.out.println(mapRe.get("remain"));
				maps.put("description", mapRe.get("description"));
				System.out.println(mapRe.get("description"));
				booklist.add(maps);
				System.out.println(i);

			}
			status = "200";
			message = "success";
			// } catch (Exception e1) {
			//
			// //e1.printStackTrace();
			// message="failure";
			// status = "400";
		} finally {
			map.put("message", message);
			System.out.println(message);
			map.put("totalPage", page.getTotalPages());
			System.out.println(page.getTotalPages());
			map.put("Page", page.getCurrentPage());
			System.out.println(page.getCurrentPage());
			map.put("totalRows", page.getTotalRows());
			System.out.println(page.getTotalRows());
			map.put("numPerPage", page.getNumPerPage());
			System.out.println(page.getNumPerPage());
			map.put("status", status);
			map.put("booklist", booklist);
			System.out.println(map);
			// 必须设置字符编码，否则返回json会乱码
			response.setContentType("text/html;charset=UTF-8");
			out.write(JSONSerializer.toJSON(map).toString());
			out.flush();
			out.close();
		}
	}
}
