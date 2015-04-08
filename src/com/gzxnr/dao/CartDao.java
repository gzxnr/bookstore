package com.gzxnr.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.AdminBean;
import com.gzxnr.bean.CartBean;
@Service
public class CartDao extends BaseDao {
	/**
	 * 将书目添加到购物车
	 * @param _cartBean
	 * @return cartID
	 * @author caokajia
	 */
	public int addBooksToCart(CartBean _cartBean){
		String sql = "insert into cart(isbn,userid,price,quantity) values(?,?,?,?)";
		Object[] _object = {_cartBean.getIsbn(),_cartBean.getUserID(),_cartBean.getPrice(),_cartBean.getQuantity()};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return getSequenceId();
	}
	/**
	 * 查找userid用户所有的购物车项目
	 * @param userid
	 * @return
	 * @author caokajia
	 */
	public List<CartBean> findMyCartItem(int userid){
		List<CartBean> cartList = null;
		String sql = "select * from cart where userid =?";
		Object[] _object = {userid};
		try {
			cartList = getJdbcTemplate().query(sql, BeanPropertyRowMapper.newInstance(CartBean.class),_object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cartList;
	}
	/**
	 * 根据userid和isbn查找购物车里的一项
	 * @param userid
	 * @param ISBN
	 * @return
	 * @author caokajia
	 */
	public int findOneCartItem(int userid, String ISBN){
		List<CartBean> cartList = null;
		String sql = "select * from cart where userid =? and isbn=?";
		Object[] _object = {userid, ISBN};
		try {
			cartList = getJdbcTemplate().query(sql, BeanPropertyRowMapper.newInstance(CartBean.class),_object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(cartList != null && cartList.size()>0){
			return cartList.get(0).getQuantity();
		}else{
			return -1;
		}
	}
	/**
	 * 根据ISBN修改购物车里该书的预购买数量
	 * @param ISBN
	 * @param quantity
	 * @return
	 * @author caokajia
	 */
	public int updateBookNumByISBN(String ISBN,int quantity){
		String sql = "update cart set quantity =? where isbn=?";
		Object[] _object = {quantity,ISBN};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return 0;
	}
	public int deleteMyCart(int userid){
		String sql = "delete from cart where userid =?";
		Object[] _object = {userid};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return 0;
	}
    public int deleteByCartid(int cartid)
    {
        String sql = "delete from cart where cartid =?";
        Object _object[] = {
            cartid
        };
        try
        {
            getJdbcTemplate().update(sql, _object);
        }
        catch(DataAccessException e)
        {
            e.printStackTrace();
        }
        return 0;
    }
    public int countCart(int userid){
    	int count = 0;
    	String sql = "select count(*) from cart where userid ="+userid;
		try {
			count = getJdbcTemplate().queryForInt(sql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return count;
    }
}
