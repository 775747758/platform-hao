package com.unitever.module.advertisement.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.unitever.module.advertisement.model.Advertisement;
import com.unitever.module.advertisement.service.AdvertisementService;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.dao.Page;
import com.unitever.platform.core.web.argument.annotation.FormModel;
import com.unitever.platform.core.web.controller.SpringController;

@Controller
@RequestMapping(value="/advertisement")
public class AdvertisementController extends SpringController {
	
	/**
	 * 跳转至商品index页面
	 * @return
	 */
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index(){
		if(advertisementService.getByUserId(UserHelper.getCurrUser().getId())==null){
			setAttribute("isHave", "no");
		}else{
			setAttribute("isHave", "yes");
		}
		return "module/advertisement/jsp/advertisement-index";
	}
	/**
	 * 跳转至商品列表页面
	 * @param page
	 * @param advertisement
	 * @return
	 */
	@RequestMapping(value="/list")
	public String list(@FormModel("page") Page<Advertisement> page, @FormModel("model") Advertisement advertisement){
		setAttribute("pageObj", advertisementService.getPage(page, advertisement));
		setAttribute("model", advertisement);
		return "module/advertisement/jsp/advertisement-list";
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
			setAttribute("model", advertisementService.getAdvertisementWithId(id));
		} else {
			setAttribute("model", new Advertisement());
		}
		setAttribute("inputKind", inputKind);
		return "module/advertisement/jsp/advertisement-input";
	}
	/**
	 * 添加修改商品
	 */
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public void saveOrUpdate(@FormModel("model") Advertisement advertisement){
		
		String inputKind = getRequest().getParameter("inputKind");
		if("update".equals(inputKind)) {
			advertisementService.update(advertisement);
		} else {
			advertisementService.save(advertisement);
		}
	}
	/**
	 * 删除商品
	 */
	@RequestMapping(value="/doDelete",method=RequestMethod.POST)
	@ResponseBody
	public void doDelete(@RequestParam(value="id") String id){
		advertisementService.deleteWithId(id);
	}
	
	@Autowired
	private AdvertisementService advertisementService;
}