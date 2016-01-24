package com.unitever.module.advertisement.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.unitever.module.advertisement.dao.manual.AdvertisementDAO;
import com.unitever.module.advertisement.model.Advertisement;
import com.unitever.module.user.model.User;
import com.unitever.platform.component.attachment.model.Attachment;
import com.unitever.platform.component.attachment.service.AttachmentService;
import com.unitever.platform.component.attachment.util.AttachmentUtil;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;

@Service
@Transactional
public class AdvertisementService {

	public List<String> getPicUrl(Advertisement advertisement) {
		List<String> urlList = new ArrayList<String>();
		for(Attachment attachment : attachmentService.getAttachmentsWithOwnerId(advertisement.getId())) {
			urlList.add(attachment.getPath()+attachment.getServerFilename());
		}
		return urlList;
	}
	
	/**
	 * 添加
	 * @param advertisement
	 */
	public void save(Advertisement advertisement) {
		User user=UserHelper.getCurrUser();
		if(advertisementDAO.getByUserId(user.getId())==null){
			advertisement.setUser(user);
			advertisementDAO.save(advertisement);
			AttachmentUtil.bindAttachment(advertisement);
		}
	}
	/**
	 * 修改
	 * @param advertisement
	 */
	public void update(Advertisement advertisement) {
		//advertisementDAO.update(advertisement);
		AttachmentUtil.bindAttachment(advertisement);
	}
	/**
	 * 根据id删除
	 * @param id
	 */
	public void deleteWithId(String id) {
		advertisementDAO.delete(id);
		AttachmentUtil.unbindAttachment(id);
	}
	/**
	 * 根据id获取商品信息
	 * @param id
	 * @return
	 */
	public Advertisement getAdvertisementWithId(String id) {
		Advertisement advertisement = advertisementDAO.get(id);
		advertisement.setPicUrls(getPicUrl(advertisement));
		return advertisement;
	}
	
	public Advertisement getByUserId(String id){
		if(StringUtils.isNotBlank(id)){
			Advertisement advertisement = advertisementDAO.getByUserId(id);
			if(advertisement!=null){
				advertisement.setPicUrls(getPicUrl(advertisement));
			}
			return advertisement;
		}
		return null;
	}
	/**
	 * 获取商品分页对象
	 * @param page
	 * @param advertisement
	 * @return
	 */
	public Page<Advertisement> getPage(Page<Advertisement> page, Advertisement advertisement) {
		List<Advertisement> advertisementList =new ArrayList<Advertisement>();
		advertisementList.add(advertisementDAO.getByUserId(UserHelper.getCurrUser().getId()));
		page.setTotalRecord(advertisementList.size());
		if (advertisementList.size() >= (page.getStartOfPage() + page.getPageSize())) {
			page.setResults(advertisementList.subList(page.getStartOfPage(), page.getStartOfPage() + page.getPageSize()));
		} else {
			page.setResults(advertisementList.subList(page.getStartOfPage(), advertisementList.size()));
		}
		return page;
	}

	@Autowired
	private AdvertisementDAO advertisementDAO;
	@Autowired
	private AttachmentService attachmentService;

}