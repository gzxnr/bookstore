package com.gzxnr.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.UserBean;

@Service
public class UserDao extends BaseDao {
	/**
	 * 根据用户名密码查询用户
	 * @param username 用户名
	 * @param password 密码
	 * @return
	 * @author caokajia
	 */
	public UserBean findUserByNamePw(String username,String password){
		List<UserBean> userList = null;
		String sql = "select * from user where username=? and password=?";
		//String sql="select * from user";
		Object[] _object = {username,password};
		UserBean user = null;
		try {
			userList = getJdbcTemplate().query(sql, 
					BeanPropertyRowMapper.newInstance(UserBean.class),_object);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(userList.size() != 0)
		{
			user = userList.get(0);
		}
		return user;
	}
	/**
	 * 根据userid查询用户
	 * @param userid
	 * @return
	 */
	public UserBean findUserByUID(int userid){
		List<UserBean> userList = null;
		String sql = "select * from user where userid=?";
		//String sql="select * from user";
		Object[] _object = {userid};
		UserBean user = null;
		try {
			userList = getJdbcTemplate().query(sql, 
					BeanPropertyRowMapper.newInstance(UserBean.class),_object);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(userList.size() != 0)
		{
			user = userList.get(0);
		}
		return user;
	}
	/**
	 * 增加新用户
	 * @param user
	 * @return 如果username已存在，则返回－1，否则新建成功返回user_id
	 * @author caokajia
	 */
	public int createNewUser(UserBean user){
		String sql_1 = "select * from user where username=?";
		Object[] _object_1 = {user.getUserName()};
		List<UserBean> userList = null;
		try {
			userList = getJdbcTemplate().query(sql_1, 
					BeanPropertyRowMapper.newInstance(UserBean.class),_object_1);
		} catch (DataAccessException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(userList.size()>0){
			return -1;
		}
		
		String sql_2 = "insert into user(userid,username,password,address,phonenum,postcode)"
				+ " values(null,?,?,?,?,?)";
		Object[] _object_2 = {user.getUserName(),user.getPassword(),user.getAddress(),
				user.getPhoneNum(),user.getPostCode()};
		try {
			getJdbcTemplate().update(sql_2, _object_2);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		int user_id = getSequenceId();
		user.setUserId(user_id);
		return getSequenceId();
	}
	
	public UserBean getUserByUserID(int userID){
		String sql = "select * from user where userid =?";
		Object[] _object = {userID};
		List<UserBean> userList = null;
		UserBean user = null;
		try {
			userList = getJdbcTemplate().query(sql, 
					BeanPropertyRowMapper.newInstance(UserBean.class),_object);
		} catch (DataAccessException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(userList.size() != 0)
		{
			user = userList.get(0);
		}
		return user;
	}
}
