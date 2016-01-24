package com.unitever.module.freight.dao.manual;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.unitever.module.freight.model.Freight;
import com.unitever.module.user.model.User;
import com.unitever.platform.core.dao.BaseDAO;

@Repository
public class FreightDAO extends BaseDAO<Freight, String>{
	
	public List<Freight> getFreightList(User user) {
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id", user.getId());
		return this.getList("getFreightList", params);
	}

}