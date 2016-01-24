package com.unitever.module.freight.service;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unitever.module.freight.dao.manual.FreightDAO;
import com.unitever.module.freight.model.Freight;
import com.unitever.module.level.model.Level;
import com.unitever.module.user.dao.manual.UserDAO;
import com.unitever.module.user.model.User;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;

@Service
@Transactional
public class FreightService {
	

	public Freight getFreight(String id) {
		return freightDAO.get(id);
	}

	public List<Freight> getFreightList(User user) {
		return freightDAO.getFreightList(user);
	}
	
	public void update(Freight freight) {
		freightDAO.update(freight);
	}
	
	public void save(Freight freight) {
		freightDAO.update(freight);
	}
	
	public Page<Freight> getPage(Page<Freight> page,User user) {
		List<Freight> userList = freightDAO.getFreightList(user);
		page.setTotalRecord(userList.size());
		if (userList.size() >= (page.getStartOfPage() + page.getPageSize())) {
			page.setResults(userList.subList(page.getStartOfPage(), page.getStartOfPage() + page.getPageSize()));
		} else {
			page.setResults(userList.subList(page.getStartOfPage(), userList.size()));
		}
		return page;
	}
	
	@Autowired
	private FreightDAO freightDAO;
}