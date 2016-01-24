package com.unitever.module.type.dao.manual;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import com.unitever.module.advertisement.model.Advertisement;
import com.unitever.module.type.model.Type;
import com.unitever.platform.core.dao.BaseDAO;

@Repository
public class TypeDAO extends BaseDAO<Type, String> {
	
	public List<Type> getByUserId(String id){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id", id);
		//this.update(sqlID, object);
		return this.getList("getByUserId", params);
	}
	
	public int getTypeNumByUserId(String id){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id", id);
		List<Integer> usrList = this.getList("getTypeNumByUserId", params);
		return usrList.size() > 0 ? usrList.get(0) : null;
	}
	
	public void deleteSetStutus(String id){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id", id);
		this.update("deleteSetStutus", params);
	}
	
	
}
