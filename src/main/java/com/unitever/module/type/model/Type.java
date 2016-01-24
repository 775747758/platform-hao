package com.unitever.module.type.model; 

import java.util.List;

import com.unitever.module.goods.model.Goods;
import com.unitever.module.user.model.User;

/** 
 * @author 作者 : 邓文杰
 * @version 创建时间：2015-12-30 下午4:26:06 
 * 类说明 :商品分类实体类
 */
public class Type {
	
	private String id;
	
	private  User user;
	
	private String name;
	
	private String status;
	
	/**删除商品*/
	public static final String TYPE_STATUS_DELETE = "0";
	/**正常商品*/
	public static final String TYPE_STATUS_NORMAL = "1";
	
	
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	private List<Goods> goodsList;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Goods> getGoodsList() {
		return goodsList;
	}

	public void setGoodsList(List<Goods> goodsList) {
		this.goodsList = goodsList;
	}
	
	

}
