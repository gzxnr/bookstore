package com.gzxnr.web.controller;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.gzxnr.bean.BookBean;
import com.gzxnr.dao.BookDao;

@Controller
public class AddBookController extends BaseController {
	@Autowired
	BookDao _bookDao;

	@RequestMapping("/addbooks.do")
	public Object addBook(HttpServletRequest request,
			HttpServletResponse response, BookBean _bookBean)
			throws IOException {
		String filename = request.getParameter("filename");
		//_bookBean.setType(new String(request.getParameter("book_name").getBytes("iso8859-1"), "utf8"));
		_bookBean.setPicture(filename);
		if (_bookDao.addBook(_bookBean) == -1) {
			request.getSession().setAttribute("addbookinfo", "ISBN已存在，添加失败");
			return "addbooks";
		} else {

			request.getSession().setAttribute("addbookinfo", "添加成功，请继续添加");
			return _bookBean;
		}
	}

	@RequestMapping("/addbooksbydouban.do")
	public Object addBooksByDouban(HttpServletRequest request, String isbn,
			String remain, String type) throws IOException {
		URL url = new URL("https://api.douban.com/v2/book/isbn/" + isbn);
		URLConnection conn = url.openConnection();
		InputStream is = conn.getInputStream();
		InputStreamReader isr = new InputStreamReader(is, "utf-8");
		BufferedReader br = new BufferedReader(isr);
		StringBuilder sb = new StringBuilder();
		for (String line = null; (line = br.readLine()) != null;)
			sb.append(line);

		br.close();
		System.out.println(sb.toString());
		JSONObject json = JSONObject.fromObject(sb.toString());
		String bookname = json.getString("title").toString();
		String authorlist = json.getString("author").toString();
		JSONArray jsonArray = JSONArray.fromObject(authorlist);
		String author = "";
		for (int i = 0; i < jsonArray.size(); i++)
			author = (new StringBuilder(String.valueOf(author))).append(
					jsonArray.getString(i)).toString();

		String press = json.getString("publisher").toString();
		Float price = Float.valueOf(json.getString("price").toString()
				.split("元")[0]);
		String description = json.getString("author_intro").toString();
		JSONObject json2 = json.getJSONObject("images");
		String pictureURL = json2.getString("large");
		byte btImg[] = getImageFromNetByUrl(pictureURL);
		String realPath = request.getSession().getServletContext()
				.getRealPath("upload");
		if (btImg != null && btImg.length > 0) {
			System.out.println("读取到：" + btImg.length + " 字节");
			String fileName = isbn + ".jpg";
			writeImageToDisk(btImg, fileName, realPath);
		} else {
			System.out
					.println("没有从该连接获得内容");
		}
		BookBean _bookBean = new BookBean();
		_bookBean.setISBN(isbn);
		_bookBean.setAuthor(author);
		_bookBean.setBookName(bookname);
		_bookBean.setDescription(description);
		_bookBean.setPicture(isbn + ".jpg");
		_bookBean.setPress(press);
		_bookBean.setRemain(Integer.valueOf(remain));
		_bookBean.setType(type);
		_bookBean.setPrice(price);
		if (_bookDao.addBook(_bookBean) == -1) {
			request.getSession().setAttribute("addbookinfo", "ISBN已存在，添加失败");
			return "quickaddbooks";
		} else {
			request.getSession()
					.setAttribute("addbookinfo", "添加成功，请继续添加");
			return "redirect:/searcher.jsp";
		}
	}

	public static void writeImageToDisk(byte img[], String fileName,
			String realPath) {
		try {
			File file = new File(realPath, fileName);
			FileOutputStream fops = new FileOutputStream(file);
			fops.write(img);
			fops.flush();
			fops.close();
			System.out.println("图片已经写入到服务器");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static byte[] getImageFromNetByUrl(String strUrl) {
		try {
			URL url = new URL(strUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(5000);
			InputStream inStream = conn.getInputStream();
			byte btImg[] = readInputStream(inStream);
			return btImg;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static byte[] readInputStream(InputStream inStream) throws Exception {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte buffer[] = new byte[1024];
		for (int len = 0; (len = inStream.read(buffer)) != -1;)
			outStream.write(buffer, 0, len);

		inStream.close();
		return outStream.toByteArray();
	}

}
