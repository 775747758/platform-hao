package com.unitever.module.type.service;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unitever.module.goods.model.Goods;
import com.unitever.module.ordergoods.model.OrderGoods;
import com.unitever.module.ordergoods.service.OrderGoodsService;
import com.unitever.module.type.dao.manual.TypeDAO;
import com.unitever.module.type.model.Type;
import com.unitever.module.user.model.User;
import com.unitever.platform.component.attachment.model.Attachment;
import com.unitever.platform.component.attachment.service.AttachmentService;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;

@Service
@Transactional
public class TypeService {

	public void deleteSetStutus(String id){
		typeDAO.deleteSetStutus(id);
	}
	
	/**
	 * 添加
	 * @param type
	 */
	public String save(Type type) {
		User user=UserHelper.getCurrUser();
		if(getTypeNumByUserId(user.getId())<5){
			type.setUser(user);
			type.setStatus(Type.TYPE_STATUS_NORMAL);
			typeDAO.save(type);
			return "success";
		}
		return "error";
	}
	/**
	 * 修改
	 * @param type
	 */
	public void update(Type type) {
		typeDAO.update(type);
	}
	/**
	 * 根据id删除
	 * @param id
	 */
	public void deleteWithId(String id) {
		typeDAO.delete(id);
	}
	/**
	 * 根据id获取商品信息
	 * @param id
	 * @return
	 */
	public Type getTypeWithId(String id) {
		Type type = typeDAO.get(id);
		List<Goods> goodsList = type.getGoodsList();
		for(int i=0;i<goodsList.size();i++) {
			goodsList.get(i).setPicUrls(getPicUrl(goodsList.get(i)));
			int totalCount = 0;
			for(OrderGoods orderGoods : orderGoodsService.getOrderGoodsListWithGoods(goodsList.get(i))) {
				totalCount = totalCount + Integer.parseInt(orderGoods.getCount());
			}
			goodsList.get(i).setTotalCount(totalCount+"");
		}
		return type;
	}
	
	public List<Type> getByUserId(String id){
		if(StringUtils.isNotBlank(id)){
			return typeDAO.getByUserId(id);
		}
		return null;
	}
	/**
	 * 获取商品分页对象
	 * @param page
	 * @param type
	 * @return
	 */
	public Page<Type> getPage(Page<Type> page, Type type) {
		List<Type> typeList =typeDAO.getByUserId(UserHelper.getCurrUser().getId());
		page.setTotalRecord(typeList.size());
		if (typeList.size() >= (page.getStartOfPage() + page.getPageSize())) {
			page.setResults(typeList.subList(page.getStartOfPage(), page.getStartOfPage() + page.getPageSize()));
		} else {
			page.setResults(typeList.subList(page.getStartOfPage(), typeList.size()));
		}
		return page;
	}
	
	public int getTypeNumByUserId(String id){
		if(StringUtils.isNotBlank(id)){
			return typeDAO.getTypeNumByUserId(id);
		}
		return 0;
	}
	
	public List<String> getPicUrl(Goods goods) {
		List<String> urlList = new ArrayList<String>();
		for(Attachment attachment : attachmentService.getAttachmentsWithOwnerId(goods.getId())) {
			urlList.add(attachment.getPath()+attachment.getServerFilename());
		}
		return urlList;
	}
	
	@Autowired
	private AttachmentService attachmentService;

	@Autowired
	private TypeDAO typeDAO;
	
	@Autowired
	private OrderGoodsService orderGoodsService;

}