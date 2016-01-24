package com.unitever.module.freight.model; 
/** 
 * @author 作者 : 邓文杰
 * @version 创建时间：2015-10-26 上午9:06:10 
 * 类说明 
 */
public class Freight {
	
	private String id;
	
	private String freight;
	
	private String limitMoney;
	
	private String userID;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFreight() {
		return freight;
	}

	public void setFreight(String freight) {
		this.freight = freight;
	}

	public String getLimitMoney() {
		return limitMoney;
	}

	public void setLimitMoney(String limitMoney) {
		this.limitMoney = limitMoney;
	}
	
}
