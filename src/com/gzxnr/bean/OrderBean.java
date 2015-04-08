package com.gzxnr.bean;

import java.sql.Timestamp;
import java.util.Date;

public class OrderBean {
	private int orderID; //数据库自增字段
	private int userID;
	private Timestamp adddate;
	private float totalPrice;
	private String detail;
	private int status;
	public int getOrderID() {
		return orderID;
	}
	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public Timestamp getAddDate() {
		return adddate;
	}
	public void setAddDate(Timestamp adddate) {
		this.adddate = adddate;
	}
	public float getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(float totalPrice) {
		this.totalPrice = totalPrice;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
	
}
