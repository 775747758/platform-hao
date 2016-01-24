package com.unitever.module.freight.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.unitever.module.freight.model.Freight;
import com.unitever.module.freight.service.FreightService;
import com.unitever.module.goods.model.Goods;
import com.unitever.module.user.model.User;
import com.unitever.module.user.service.UserService;
import com.unitever.module.weChat.util.WeChatUtil;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;
import com.unitever.platform.core.web.argument.annotation.FormModel;
import com.unitever.platform.core.web.controller.SpringController;

@Controller
@RequestMapping(value="/freight")
public class FreightController extends SpringController {

	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index(){
		return "module/freight/jsp/freight-index";
	}

	
	@RequestMapping(value="/list")
	public String list(@FormModel("page") Page<Freight> page){
		User user=UserHelper.getCurrUser();
		setAttribute("pageObj", freightService.getPage(page, UserHelper.getCurrUser()));
		return "module/freight/jsp/freight-list";
	}


	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public void saveOrUpdate(@FormModel("model") Freight freight){
		freightService.update(freight);
	}
	
	/**
	 * 跳转至添加修改页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/input",method=RequestMethod.GET)
	public String input(@RequestParam(value="id", required = false) String id){
		String inputKind = getRequest().getParameter("inputKind");
		if("update".equals(inputKind)) {
			setAttribute("model", freightService.getFreight(id));
		} else {
			setAttribute("model", new Freight());
		}
		setAttribute("inputKind", inputKind);
		return "module/freight/jsp/freight-input";
	}
	
	
	@Autowired
	private FreightService freightService;
}