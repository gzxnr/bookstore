package com.gzxnr.dao;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.BookBean;
import com.gzxnr.bean.CartBean;
import com.gzxnr.bean.OrderBean;
import com.gzxnr.util.Pagination;

@Service
public class OrderDao extends BaseDao {
	/**
	 * 将用户购物车里的商品计算总价形成订单
	 * 
	 * @param cartList
	 * @return
	 * @author caokajia
	 */
	@Autowired
	BookDao _bookDao;

	public int addCartToOrder(List<CartBean> cartList) {
		float totalPrice = 0;
		String detail = "";
		Date date = new Date();//获得系统时间.
		String nowTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(date);//将时间格式转换成符合Timestamp要求的格式.
		Timestamp addtime =Timestamp.valueOf(nowTime);//把时间转换
		for (CartBean cb : cartList) {
			// 将购物车里每项数量与售价相乘叠加得到总价
			BookBean book = _bookDao.getBookByISBN(cb.getIsbn());
			if (book.getDiscount() != null) {
				totalPrice = totalPrice + cb.getPrice() * cb.getQuantity()
						* Integer.valueOf(book.getDiscount()) / 10;
			} else {
				totalPrice = totalPrice + cb.getPrice() * cb.getQuantity();
			}
			// 将书的ISBN和书名生成订单详情
			detail = detail + "ISBN:" + cb.getIsbn() + "  书名："
					+ _bookDao.getBookByISBN(cb.getIsbn()).getBookName()
					+ " 数量：" + cb.getQuantity() + "</br>";
		}
		System.out.println("总价：" + totalPrice);
		System.out.println("detail：" + detail);
		String sql = "insert into `order`(userid,adddate,totalprice,detail,status) values(?,?,?,?,?)";
		Object[] _object = { cartList.get(0).getUserID(), addtime, totalPrice,
				detail,0};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return getSequenceId();

	}

	public List<OrderBean> findMyOrder(int userid) {
		List<OrderBean> orderlist = null;
		String sql = "select * from `order` where userid=? order by orderid desc";
		Object[] _object = { userid };
		try {
			orderlist = getJdbcTemplate()
					.query(sql,
							BeanPropertyRowMapper.newInstance(OrderBean.class),
							_object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return orderlist;
	}
	public Pagination findAllOrders(Integer currentPage, Integer numPerPage){
		String sql = "SELECT * FROM `order` order by orderid desc";
		Pagination page = new Pagination(sql, currentPage, numPerPage,
				getJdbcTemplate());
		return page;
	}
	public void updateOrderStatus(int newStatus,int orderid){
		String sql = "update `order` set status =? where orderid=?";
		Object[] _object = {newStatus,orderid};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
}
