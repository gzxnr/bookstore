package com.gzxnr.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.CommentBean;

@Service
public class CommentDao extends BaseDao{
	public List<CommentBean> getBooksComments(String isbn){
		List<CommentBean> cartList = null;
		String sql = "select * from comment where isbn =?";
		Object[] _object = {isbn};
		try {
			cartList = getJdbcTemplate().query(sql, BeanPropertyRowMapper.newInstance(CommentBean.class),_object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cartList;
	}
	public int addComment(String isbn, int userid, String comments){
		String sql = "insert into comment(isbn,userid,comments) values(?,?,?)";
		Object[] _object = {isbn,userid,comments};
		try {
			getJdbcTemplate().update(sql, _object);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return getSequenceId();
	}
}
