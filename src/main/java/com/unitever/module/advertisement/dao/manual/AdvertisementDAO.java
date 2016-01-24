package com.unitever.module.advertisement.dao.manual;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.unitever.module.advertisement.model.Advertisement;
import com.unitever.module.goods.model.Goods;
import com.unitever.module.user.model.User;
import com.unitever.platform.core.dao.BaseDAO;

@Repository
public class AdvertisementDAO extends BaseDAO<Advertisement, String> {
	
	public Advertisement getByUserId(String id){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id", id);
		List<Advertisement> usrList = this.getList("getByUserId", params);
		return usrList.size() > 0 ? usrList.get(0) : null;
	}
	
	
}
