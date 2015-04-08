package com.gzxnr.web.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.gzxnr.dao.BookDao;


/**
 * SpringMVC中的文件上传
 * @see 第一步：由于SpringMVC使用的是commons-fileupload实现，故将其组件引入项目中
 * @see       这里用到的是commons-fileupload-1.2.2.jar和commons-io-2.0.1.jar
 * @see 第二步：在####-servlet.xml中配置MultipartResolver处理器。可在此加入对上传文件的属性限制
 * @see 第三步：在Controller的方法中添加MultipartFile参数。该参数用于接收表单中file组件的内容
 * @see 第四步：编写前台表单。注意enctype="multipart/form-data"以及<input type="file" name="****"/>
 * @author 宏宇
 * @create May 12, 2012 1:26:21 AM
 */
@Controller

public class UploadController extends BaseController {
	@Autowired
	BookDao _bookDao;
	@RequestMapping("/upload.do")
	public String addUser(@RequestParam("pic") MultipartFile file,
			HttpServletRequest request, String _isbn) throws IOException {
		// 如果只是上传一个文件，则只需要MultipartFile类型接收文件即可，而且无需显式指定@RequestParam注解
		// 如果想上传多个文件，那么这里就要用MultipartFile[]类型来接收文件，并且还要指定@RequestParam注解
		// 并且上传多个文件时，前台表单中的所有<input
		// type="file"/>的name都应该是myfiles，否则参数里的myfiles无法获取到所有上传的文件
		String filename = "";
		if (file.isEmpty()) {
			System.out.println("文件未上传");
		} else {
			filename = file.getName();
			System.out.println(_isbn);
			System.out.println("文件长度: " + file.getSize());
			System.out.println("文件类型: " + file.getContentType());
			System.out.println("文件名称: " + file.getName());
			System.out.println("文件原名: " + file.getOriginalFilename());
			String rename = "";
			System.out.println("========================================");
			// 如果用的是Tomcat服务器，则文件会上传到\\%TOMCAT_HOME%\\webapps\\YourWebProject\\WEB-INF\\upload\\文件夹中
			String realPath = request.getSession().getServletContext()
					.getRealPath("upload");
			System.out.println("文件路径: " +realPath);
			rename = _isbn+".jpg";//修改封面图片文件名为isbn号
			// 这里不必处理IO流关闭的问题，因为FileUtils.copyInputStreamToFile()方法内部会自动把用到的IO流关掉，我是看它的源码才知道的
			FileUtils.copyInputStreamToFile(file.getInputStream(), new File(
					realPath, rename));	
			if(!_isbn.isEmpty()&&_isbn!=null){
				_bookDao.updatePicByISBN(_isbn, rename);
			}
			
		}
		return "addbooks";
	}
	
}
