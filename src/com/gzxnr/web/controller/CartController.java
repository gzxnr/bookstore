package com.gzxnr.web.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import com.gzxnr.dao.BookDao;
import com.gzxnr.dao.CartDao;
import com.gzxnr.dao.OrderDao;

@Controller
public class CartController extends BaseController {
	@Autowired
	CartDao _cartDao;
	@RequestMapping("/addtocart.do")
	public Object AddToCart(HttpServletRequest request, int buynum,float price, int userid, String isbn){
		BookBean _bookBean;
		int quantity;
		CartBean _cartBean = new CartBean();
		System.out.println("BuyNum:"+buynum);
		System.out.println("so do u have userid:"+ userid);
		System.out.println("so do u have isbn:"+ isbn);
		System.out.println("so do u have price:"+ price);
		System.out.println("-------------->");
		quantity = _cartDao.findOneCartItem(userid, isbn);
		if( quantity != -1 ){//如果购物车里已有此书则更新购买数量
			_cartDao.updateBookNumByISBN(isbn, buynum + quantity);
		} else {//如果购物车里没有则生成新的Cart项目
			_cartBean.setIsbn(isbn);
			_cartBean.setPrice(price);
			_cartBean.setQuantity(buynum);
			_cartBean.setUserID(userid);
			_cartDao.addBooksToCart(_cartBean);
		}
		
		return ("redirect:/mycart.jsp?userid=" + userid);
	}
	@Autowired
	BookDao _bookDao;
	@RequestMapping("/showcart.do")
	public void ShowCart(HttpServletRequest request, HttpServletResponse response) throws IOException{
		List<CartBean> cartList = null; 
		BookBean _bookBean;
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> showlist = new ArrayList<Map<String, Object>>();
		int userid  = Integer.parseInt(request.getParameter("userid"));
		System.out.println("购物车页面userid：" + userid);
		PrintWriter out = null;
		cartList = _cartDao.findMyCartItem(userid);
		
		if (cartList != null) {
			for (CartBean item : cartList) {
				Map<String, Object> maps = new HashMap<String, Object>();
				maps.put("cartid", String.valueOf(item.getCartID())); System.out.println(item.getCartID());
				maps.put("isbn", item.getIsbn());System.out.println(item.getIsbn());
				maps.put("bookname", "");System.out.println();
				maps.put("price", String.valueOf(item.getPrice()));System.out.println(item.getPrice());
				maps.put("buynum", String.valueOf(item.getQuantity()));System.out.println(item.getQuantity());
				_bookBean = _bookDao.getBookByISBN(item.getIsbn());
				if (_bookBean != null) {
					maps.put("bookname", _bookBean.getBookName());System.out.println(_bookBean.getBookName());
					maps.put("description", _bookBean.getDescription());System.out.println(_bookBean.getDescription());
					maps.put("pic", _bookBean.getPicture());System.out.println(_bookBean.getPicture());
					maps.put("author", _bookBean.getAuthor());System.out.println(_bookBean.getAuthor());
					maps.put("press", _bookBean.getPress());System.out.println(_bookBean.getPress());
				}
				showlist.add(maps);
			}
		}else{
			Map<String, Object> maps = new HashMap<String, Object>();
			maps.put("info", "error");
			showlist.add(maps);
		}
		map.put("message", "success");
		map.put("cartshowlist", showlist);
		System.out.println(map);
		JSONObject json = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);

		//out.write(JSONSerializer.toJSON(map).toString());
		//out.flush();
		//out.close();
	}
	@Autowired
	OrderDao _orderDao;
	@RequestMapping("/gotobuy.do")
	public Object AddToOrder(HttpServletRequest request, int userid){
		List<CartBean> cartBeanList = _cartDao.findMyCartItem(userid);
		
		for(CartBean cb:cartBeanList){
			BookBean _bookBean = _bookDao.getBookByISBN(cb.getIsbn());
			if(_bookBean.getRemain()-cb.getQuantity() < 0){
				request.getSession().setAttribute("buymessage","数量超过库存");
				return "mycart";
			}else{
				_bookDao.updateRemainByISBN(cb.getIsbn(), _bookBean.getRemain()-cb.getQuantity());
			}
		}
		int orderID = _orderDao.addCartToOrder(cartBeanList);
		_cartDao.deleteMyCart(userid);//清空购物车
		
		return ("redirect:/order.jsp?userid=" + userid);
	}
	@RequestMapping("/deletecart.do")
    public int DeleteCartByCartID(HttpServletRequest request)
    {
        int cartid = Integer.parseInt(request.getParameter("cartid"));
        return _cartDao.deleteByCartid(cartid);
    }
}
