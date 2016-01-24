package com.unitever.module.type.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.unitever.module.type.model.Type;
import com.unitever.module.type.service.TypeService;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;
import com.unitever.platform.core.web.argument.annotation.FormModel;
import com.unitever.platform.core.web.controller.SpringController;

@Controller
@RequestMapping(value="/type")
public class TypeController extends SpringController {
	
	/**
	 * 跳转至商品index页面
	 * @return
	 */
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index(){
		return "module/type/jsp/type-index";
	}
	/**
	 * 跳转至商品列表页面
	 * @param page
	 * @param type
	 * @return
	 */
	@RequestMapping(value="/list")
	public String list(@FormModel("page") Page<Type> page, @FormModel("model") Type type){
		setAttribute("pageObj", typeService.getPage(page, type));
		setAttribute("model", type);
		return "module/type/jsp/type-list";
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
			setAttribute("model", typeService.getTypeWithId(id));
		} else {
			setAttribute("model", new Type());
		}
		setAttribute("inputKind", inputKind);
		return "module/type/jsp/type-input";
	}
	/**
	 * 添加修改商品
	 */
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@FormModel("model") Type type){
		String inputKind = getRequest().getParameter("inputKind");
		if("update".equals(inputKind)) {
			typeService.update(type);
			return "success";
		} else {
			return typeService.save(type);
		}
	}
	/**
	 * 删除商品
	 */
	@RequestMapping(value="/doDelete",method=RequestMethod.POST)
	@ResponseBody
	public void doDelete(@RequestParam(value="id") String id){
		typeService.deleteSetStutus(id);
	}
	
	@Autowired
	private TypeService typeService;
}