package com.gzxnr.dao;

import java.util.List;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.AdminBean;
@Service
public class AdminDao extends BaseDao {
	/**
	 * 根据用户名密码查询用户
	 * @param username 用户名
	 * @param password 密码
	 * @return
	 * @author caokajia
	 */
	public AdminBean findAdminByNamePw(String username,String password){
		List<AdminBean> adminList = null;
		String sql = "select * from admin where adminname=? and password=?";
		Object[] _object = {username,password};
		AdminBean admin = null;
		try {
			adminList = getJdbcTemplate().query(sql, 
					BeanPropertyRowMapper.newInstance(AdminBean.class),_object);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(adminList.size() != 0)
		{
			admin = adminList.get(0);
		}
		return admin;
	}
}
