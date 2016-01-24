package com.unitever.module.advertisement.model; 

import java.util.List;

import com.unitever.module.user.model.User;
import com.unitever.platform.component.attachment.annotation.AttachmentAnnotation;

/** 
 * @author 作者 : 邓文杰
 * @version 创建时间：2015-12-28 下午1:46:15 
 * 类说明 
 */
@AttachmentAnnotation
public class Advertisement {
	
	private String id;
	private String name;
	private List<String> picUrls;
	private User user;
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<String> getPicUrls() {
		return picUrls;
	}

	public void setPicUrls(List<String> picUrls) {
		this.picUrls = picUrls;
	}

	public Advertisement() {
		super();
	}

	public Advertisement(String id, String name) {
		this.id = id;
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
	
	

}
