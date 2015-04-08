package com.gzxnr.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Service;

import com.gzxnr.bean.BookBean;
import com.gzxnr.util.Pagination;

@Service
public class BookDao extends BaseDao {
	/**
	 * 根据条件分页查询
	 * 
	 * @param currentPage
	 *            当前页
	 * @param numPerPage
	 *            每页记录数
	 * @return Pagination 每一页的查询结果集
	 * @author caokajia
	 */
	public Pagination queryBooksBusiness(Integer currentPage,
			Integer numPerPage, String ISBN, String bookname, String author,
			String press, String type) {
		String sql = "SELECT * FROM BOOK";
		if ((ISBN != null && !ISBN.isEmpty())
				|| (bookname != null && !bookname.isEmpty())
				|| (author != null && !author.isEmpty())
				|| (press != null && !press.isEmpty())
				|| (type != null && !type.isEmpty())) {
			sql = sql + " where 1=1";
			if (ISBN != null && !ISBN.isEmpty()) {
				sql = sql + " and isbn LIKE'%" + ISBN + "%'";
			}
			if (bookname != null && !bookname.isEmpty()) {
				sql = sql + " and book_name LIKE'%" + bookname + "%'";
			}
			if (author != null && !author.isEmpty()) {
				sql = sql + " and author LIKE'%" + author + "%'";
			}
			if (press != null && !press.isEmpty()) {
				sql = sql + " and press LIKE'%" + press + "%'";
			}
			if (type != null && !type.isEmpty()) {
				sql = sql + " and type LIKE'%" + type + "%'";
			}
		}
		Pagination page = new Pagination(sql, currentPage, numPerPage,
				getJdbcTemplate());
		return page;
	}

	/**
	 * 添加新书，首先验证ISBN是否已存在，若存在则不允许添加
	 * 
	 * @param _bookBean
	 * @return 如果添加成功返回-1，否则返回0
	 * @author caokajia
	 */
	public int addBook(BookBean _bookBean) {
		String sql_1 = "select * from book where isbn=?";
		Object[] _object_1 = { _bookBean.getISBN() };
		List<BookBean> booklist = null;
		try {
			booklist = getJdbcTemplate().query(sql_1,
					BeanPropertyRowMapper.newInstance(BookBean.class),
					_object_1);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (booklist.size() > 0) {
			return -1;
		}
		String sql_2 = "insert into book(isbn,book_name,author,press,type,price,remain,picture,description)"
				+ " values(?,?,?,?,?,?,?,?,?)";
		Object[] _object_2 = { _bookBean.getISBN(), _bookBean.getBookName(),
				_bookBean.getAuthor(), _bookBean.getPress(),
				_bookBean.getType(), _bookBean.getPrice(),
				_bookBean.getRemain(), _bookBean.getPicture(),
				_bookBean.getDescription() };
		try {
			getJdbcTemplate().update(sql_2, _object_2);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * 根据ISBN获得该书的书名
	 * 
	 * @param isbn
	 * @return
	 */
	public BookBean getBookByISBN(String isbn) {
		String sql = "select * from book where isbn=?";
		List<BookBean> bookList = null;
		Object[] _object = { isbn };
		try {
			bookList = getJdbcTemplate().query(sql,
					BeanPropertyRowMapper.newInstance(BookBean.class), _object);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (bookList != null && bookList.size() > 0) {
			BookBean book = bookList.get(0);
			return book;
		} else {
			return null;
		}
	}
	
	public List<BookBean> getAdvicedBooks(){
		String sql = "select * from book where advice = ?";
		Object[] _object = { 1 };
		List<BookBean> bookList = null;
		try {
			bookList = getJdbcTemplate().query(sql,
					BeanPropertyRowMapper.newInstance(BookBean.class), _object);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return bookList;
	}

	/**
	 * 根据isbn更新书的封面
	 * 
	 * @param isbn
	 * @param pic
	 */
	public void updatePicByISBN(String isbn, String pic) {
		String sql = "update book set picture=? where isbn=?";
		Object[] _object = { pic, isbn };
		getJdbcTemplate().update(sql, _object);
	}

	/**
	 * 根据isbn更新库存
	 * 
	 * @param isbn
	 * @param remain
	 */
	public void updateRemainByISBN(String isbn, int remain) {
		String sql = "update book set remain=? where isbn=?";
		Object[] _object = { remain, isbn };
		getJdbcTemplate().update(sql, _object);
	}

	/**
	 * 根据isbn更新折扣
	 * 
	 * @param isbn
	 * @param discount
	 */
	public void updateDiscountByISBN(String isbn, String discount) {
		String sql = "update book set discount=? where isbn=?";
		Object[] _object = { discount, isbn };
		getJdbcTemplate().update(sql, _object);
	}

	public void updateAdviceByISBN(String isbn, int flag) {
			String sql = "update book set advice=? where isbn=?";
			Object[] _object = {flag, isbn };
			getJdbcTemplate().update(sql, _object);
	}

}
