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
import com.gzxnr.bean.OrderBean;
import com.gzxnr.bean.UserBean;
import com.gzxnr.dao.OrderDao;
import com.gzxnr.dao.UserDao;
import com.gzxnr.util.Pagination;

@Controller
public class OrderController extends BaseController {
	@Autowired
	private OrderDao _orderDao;
	@Autowired
	private UserDao _userDao;

	@RequestMapping("/showorderlist.do")
	public void showMyOrder(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		List<OrderBean> orderlist = null;
		BookBean _bookBean;
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> showlist = new ArrayList<Map<String, Object>>();
		int userid = Integer.parseInt(request.getParameter("userid"));
		System.out.println("订单页面userid：" + userid);
		orderlist = _orderDao.findMyOrder(userid);
		UserBean _userBean;
		if (orderlist != null) {
			for (OrderBean item : orderlist) {
				Map<String, Object> maps = new HashMap<String, Object>();
				maps.put("orderid", item.getOrderID());
				System.out.println(item.getOrderID());
				maps.put("addtime", item.getAddDate().toString());
				System.out.println(item.getAddDate());
				maps.put("totalprice", item.getTotalPrice());
				System.out.println(item.getTotalPrice());
				maps.put("detail", item.getDetail());
				System.out.println(item.getDetail());
				_userBean = _userDao.getUserByUserID(userid);
				if (_userBean != null) {
					maps.put("address", _userBean.getAddress());
					System.out.println(_userBean.getAddress());
				} else {
					maps.put("address", "");
				}
				String status = "";
				System.out.println("状态：" + item.getStatus());
				switch (item.getStatus()) {
				case 0: {
					status = "等待发货";
					break;
				}
				case 1: {
					status = "确认收货";
					break;
				}
				case 2: {
					status = "已收货";
					break;
				}
				}
				System.out.println(status);
				maps.put("status", status);
				showlist.add(maps);
			}
		} else {
			Map<String, Object> maps = new HashMap<String, Object>();
			maps.put("info", "error");
			showlist.add(maps);
		}
		map.put("message", "success");
		map.put("ordershowlist", showlist);
		System.out.println(map);
		JSONObject json = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
	}

	@RequestMapping("/showallorderlist.do")
	public void queryOrders(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String status = "";
		PrintWriter out = null;
		Pagination page = null;
		List<Map<String, Object>> orderlist = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String currentPage = java.net.URLDecoder.decode(
				request.getParameter("Page"), "UTF-8");
		System.out.println("page:"+currentPage);
		String numPerPage = java.net.URLDecoder.decode(
				request.getParameter("numPerPage"), "UTF-8");
		if ("".equals(currentPage) || "".equals(numPerPage)) {
			page = _orderDao.findAllOrders(1, 10);
		} else {
			page = _orderDao.findAllOrders(Integer.parseInt(currentPage),
					Integer.parseInt(numPerPage));
		}
		List list = page.getResultList();
		int len = list.size();
		System.out.println("结果集记录数：" + len);
		for (int i = 0; i < len; i++) {
			Map<String, Object> maps = new HashMap<String, Object>();
			Map mapRe = (Map) list.get(i);
			maps.put("orderid", mapRe.get("orderid").toString());

			int uid = Integer.valueOf(mapRe.get("userid").toString());
			maps.put("userid", uid);
			maps.put("adddate", mapRe.get("adddate").toString());

			

			maps.put("totalprice", mapRe.get("totalprice").toString());

			maps.put("detail", mapRe.get("detail").toString());
			maps.put("status", mapRe.get("status").toString());
			UserBean _userBean = _userDao.getUserByUserID(uid);
			if (_userBean != null) {
				maps.put("username", _userBean.getUserName());
				maps.put("address", _userBean.getAddress());
			} else {
				maps.put("username", "");
				maps.put("address", "");
			}
			switch (mapRe.get("status").toString()) {
			case "0": {
				status = "发货";
				break;
			}
			case "1": {
				status = "已发货";
				break;
			}
			case "2": {
				status = "已收货";
				break;
			}
			}
			maps.put("status", status);
			//maps.put("username", mapRe.get("username").toString());
			orderlist.add(maps);
		}
		map.put("totalPage", page.getTotalPages());

		map.put("Page", page.getCurrentPage());

		map.put("totalRows", page.getTotalRows());

		map.put("numPerPage", page.getNumPerPage());

		map.put("orderlist", orderlist);
		map.put("message", "success");
		System.out.println(map);
		JSONObject json = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
	}
	@RequestMapping("/changeorderstatus.do")
	public void changeOrderStatus(HttpServletRequest request,
			HttpServletResponse response){
		int orderid  = Integer.valueOf(request.getParameter("orderid"));
		int newStatus  = Integer.valueOf(request.getParameter("newstatus"));
		_orderDao.updateOrderStatus(newStatus, orderid);
	}
}
