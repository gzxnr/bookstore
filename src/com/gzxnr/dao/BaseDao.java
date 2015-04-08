package com.gzxnr.dao;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;

public class BaseDao {
	private DataSource dataSource; 
	private JdbcTemplate jdbcTemplate;
	private SimpleJdbcTemplate simpleJdbcTemplate;

	/**
	 * 获取数据源
	 * @return 数据源
	 * @author Administrator
	 * @2013-5-3下午03:00:51
	 */
	public DataSource getDataSource() {
		return dataSource;
	}


	/**
	 * 注入数据源
	 * @param dataSource 给dataSource赋值
	 * @2013-5-3下午03:01:39
	 */
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
		this.simpleJdbcTemplate = new SimpleJdbcTemplate(dataSource);
		this.dataSource = dataSource;
	}

	
	/**
	 * 获取JDBC模板
	 * @return jdbc模板
	 * @2013-5-3下午03:22:01
	 */
	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public SimpleJdbcTemplate getSimpleJdbcTemplate() {
		return simpleJdbcTemplate;
	}
	public int getSequenceId() { // 取出这一次产生的id值
		String sql = "select LAST_INSERT_ID()";
		int id = -1;
		try {
			id = jdbcTemplate.queryForInt(sql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return id;
	}
}
