package com.gzxnr.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gzxnr.dao.BookDao;
import com.gzxnr.util.Pagination;

@Service("SearchService")
public class SearchService {
	@Resource
	private BookDao _bookDao;
	  public Pagination queryBooksBusiness(Integer currentPage,Integer numPerPage,
			  String ISBN, String bookname, String author, String press, String type){
		  return _bookDao.queryBooksBusiness(currentPage, numPerPage, ISBN, bookname, author, press, type);
	  }
}
