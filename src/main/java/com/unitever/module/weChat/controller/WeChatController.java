package com.unitever.module.weChat.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.unitever.module.advertisement.service.AdvertisementService;
import com.unitever.module.customer.model.Customer;
import com.unitever.module.customer.service.CustomerService;
import com.unitever.module.evaluation.model.Evaluation;
import com.unitever.module.evaluation.service.EvaluationService;
import com.unitever.module.freight.model.Freight;
import com.unitever.module.freight.service.FreightService;
import com.unitever.module.goods.service.GoodsService;
import com.unitever.module.order.model.Order;
import com.unitever.module.order.service.OrderService;
import com.unitever.module.ordergoods.service.OrderGoodsService;
import com.unitever.module.propaganda.service.PropagandaService;
import com.unitever.module.shoppingcart.service.ShoppingCartService;
import com.unitever.module.type.model.Type;
import com.unitever.module.type.service.TypeService;
import com.unitever.module.user.model.User;
import com.unitever.module.user.service.UserService;
import com.unitever.module.weChat.service.WeChatService;
import com.unitever.module.weChat.util.CookieUtil;
import com.unitever.module.weChat.util.MessageUtil;
import com.unitever.module.weChat.util.RequestUrlUtil;
import com.unitever.module.weChat.util.SignUtil;
import com.unitever.module.weChat.util.WeChatUtil;
import com.unitever.module.weChat.vo.ShoppingCartVo;
import com.unitever.module.withdrawCash.model.WithdrawCash;
import com.unitever.module.withdrawCash.service.WithdrawCashService;
import com.unitever.platform.core.common.helper.UserHelper;
import com.unitever.platform.core.web.argument.annotation.FormModel;
import com.unitever.platform.core.web.controller.SpringController;
import com.unitever.platform.util.JsonUtil;
import com.unitever.platform.util.mail.MailSendHelper;

@Controller
@RequestMapping(value="/weChat")
public class WeChatController extends SpringController {

	/**
	 * 处理微信响应请求
	 * @param signature
	 * @param timestamp
	 * @param nonce
	 * @param echostr
	 * @return
	 */
	@RequestMapping(value="/weChatHandler")
	@ResponseBody
	public String weChatHandler(@RequestParam(value="signature", required = false) String signature, 
			@RequestParam(value="timestamp", required = false) String timestamp,
			@RequestParam(value="nonce", required = false) String nonce, 
			@RequestParam(value="echostr", required = false) String echostr){
		try {
			if("GET".equals(getRequest().getMethod())){
				if (SignUtil.checkSignature(signature, timestamp, nonce)) {
					return echostr;
				}
			} else if("POST".equals(getRequest().getMethod())) {
				if (SignUtil.checkSignature(signature, timestamp, nonce)) {
					return weChatService.weChatHandler(getRequest());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	/**
	 * 跳转至商品列表页面
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping(value="/wcGoodsList",method=RequestMethod.GET)
	public String wcGoodsList(@RequestParam(value="code", required = false) String code,
			@RequestParam(value="state", required = false) String state,
			@RequestParam(value="typeId", required = false) String typeId,
			@RequestParam(value="customerId", required = false) String customerId){
		try {
			User user = new User();
			Customer customer = new Customer();
			user = userService.getUserWithWeChatNum(state);
			if(StringUtils.isNotBlank(code)&&StringUtils.isNotBlank(state)) {
				if(CookieUtil.getCookieByName(getRequest(), "openid"+state)==null){
					customer = customerService.getCustomerWithCodeUser(code, user);
					if(customer==null||customer.getId()==null){
						customerService.saveWithWeChatNumParentId(state, customer.getWeChatNum(), null);
						customer = customerService.getCustomerWithWeChatNum(customer.getWeChatNum(), user);
					}
					CookieUtil.addCookie(getResponse(), "openid"+state,  customer.getWeChatNum(), 1000*60*5);
				}else{//用户第二回点击直接，直接使用session中的userId
					String openid=CookieUtil.getCookieByName(getRequest(), "openid"+state).getValue();
					customer = customerService.getCustomerWithWeChatNum(openid, user);
				}
				
			} else if(StringUtils.isNotBlank(customerId)){
				customer = customerService.getCustomerWithId(customerId);
				user=customer.getUser();
			}
			Freight freight=freightService.getFreightList(user).get(0);
			setAttribute("freight", freight.getFreight());
			setAttribute("limitMoney", freight.getLimitMoney());
			setAttribute("customer", customer);
			if(StringUtils.isBlank(customer.getName())){
				String str = WeChatUtil.httpRequest(RequestUrlUtil.getUserInfoUrl(WeChatUtil.getAccessToken(customer.getUser()), customer.getWeChatNum()), "GET", null);
				Map<String, String> customerMap = JsonUtil.json2Map(str);
				if(StringUtils.isNotBlank(customerMap.get("nickname"))){
					customer.setName(customerMap.get("nickname"));
					customerService.update(customer);
				}
			}
			if(StringUtils.isBlank(typeId)){
				setAttribute("goodsList", goodsService.getGoodsListWithUserCustomer(customer));
				setAttribute("typeName", "全部商品");
			}else{
				Type type=typeService.getTypeWithId(typeId);
				setAttribute("goodsList", type.getGoodsList());
				setAttribute("typeName", type.getName());
			}
			setAttribute("advertisement", advertisementService.getByUserId(user.getId()));
			setAttribute("typeList", typeService.getByUserId(user.getId()));
			setAttribute("user", user);
			if("gh_714de1921eb7".equals(user.getWeChatNum())){
				return "module/weChat/jsp/weChat-goodsList-gpy";
			}else{
				return "module/weChat/jsp/weChat-goodsList";
			}
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至商品详细页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/wcGoodsView",method=RequestMethod.GET)
	public String wcGoodsView(@RequestParam(value="id") String id, @RequestParam(value="customerId") String customerId){
		try {
			setAttribute("model", goodsService.getGoodsWithId(id));
			setAttribute("evaluationList", evaluationService.getEvaluationListWithGoodsId(id));
			setAttribute("customerId", customerId);
			Customer customer=customerService.getCustomerWithId(customerId);
			//setAttribute("customer",customer);
			Freight freight=freightService.getFreightList(customer.getUser()).get(0);
			setAttribute("freight",freight.getFreight());
			return "module/weChat/jsp/weChat-goodsView";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至购物车页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/shoppingCart",method=RequestMethod.GET)
	public String shoppingCart(@RequestParam(value="customerId") String customerId){
		try {
			setAttribute("shoppingCartVo", shoppingCartService.getShoppingCartVoWithCustomerId(customerId));
			return "module/weChat/jsp/weChat-shoppingCart";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 添加到购物车
	 */
	@RequestMapping(value="/addShoppingCart",method=RequestMethod.POST)
	@ResponseBody
	public void addShoppingCart(@RequestParam(value="goodsId") String goodsId, @RequestParam(value="customerId") String customerId){
		try {
			shoppingCartService.save(goodsId, customerId);
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	/**
	 * 从购物车删除
	 */
	@RequestMapping(value="/shoppingCartDelete",method=RequestMethod.POST)
	@ResponseBody
	public void shoppingCartDelete(@RequestParam(value="id") String id){
		try {
			shoppingCartService.doDelete(id);
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	/**
	 * 跳转至下订单页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcOrderInput",method=RequestMethod.POST)
	public String wcOrderInput(@RequestParam(value="customerId") String customerId, @RequestParam(value="shoppingCartIds") String shoppingCartIds){
		try {
			shoppingCartService.updateWithGoodsIdsCustomerId(getRequest(), shoppingCartIds);
			Customer customer=customerService.getCustomerWithId(customerId);
			Freight freight=freightService.getFreightList(customer.getUser()).get(0);
			ShoppingCartVo  shoppingCartVo=shoppingCartService.getShoppingCartVoWithCustomerId(customerId);
			setAttribute("shoppingCartVo",shoppingCartVo );
			float freightPrice=Float.parseFloat(shoppingCartVo.getPrice())>=Float.parseFloat(freight.getLimitMoney())?0f:Float.parseFloat(freight.getFreight());
			setAttribute("freight",freightPrice);
			setAttribute("totalPrice",String.format("%.2f", freightPrice+Float.parseFloat(shoppingCartVo.getPrice())));
			return "module/weChat/jsp/weChat-orderInput";
		} catch (NumberFormatException e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	/**
	 * 添加订单
	 */
	@RequestMapping(value="/orderSave",method=RequestMethod.GET)
	@ResponseBody
	public void orderSave(@RequestParam(value="customerId") String customerId, @RequestParam(value="receiver") String receiver,
			@RequestParam(value="receiverPhoneNum") String receiverPhoneNum, @RequestParam(value="receiveAddress") String receiveAddress,String freight){
		try {
			Order order = orderService.saveWithParm(customerId, receiver, receiverPhoneNum, receiveAddress,freight);
			this.print(weChatService.getWeChatPaymentJsonWithOrder(order, getRequest()));
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	/**
	 * 确认付款
	 */
	@RequestMapping(value="/payment")
	@ResponseBody
	public void payment(){
		try {
			Map<String, String> requestMap = MessageUtil.parseXml(getRequest());
			String orderId = requestMap.get("orderId");
			System.out.println(orderId);
			Order order = orderService.getOrderWithId(orderId);
			if(Order.ORDER_STATE_UNPAYMENT.equals(order.getState())) {
				orderService.payment(orderId);
			}
			this.print("<xml><return_code><![CDATA[SUCCESS"
	                + "]]></return_code><return_msg><![CDATA["
	                + "]]></return_msg></xml>");
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		} 
	}
	/**
	 * 跳转至支付成功页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcPaymentSuccess",method=RequestMethod.GET)
	public String wcPaymentSuccess(@RequestParam(value="orderId") String orderId){
		try {
			setAttribute("order", orderService.getOrderWithId(orderId));
			return "module/weChat/jsp/weChat-paymentSuccess";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至支付成功页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcPaymentFail",method=RequestMethod.GET)
	public String wcPaymentFail(@RequestParam(value="orderId", required = false) String orderId, @RequestParam(value="customerId") String customerId){
		try {
			setAttribute("customerId", customerId);
			return "module/weChat/jsp/weChat-paymentFail";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至个人中心页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/wcPersonalCenter",method=RequestMethod.GET)
	public String wcPersonalCenter(@RequestParam(value="customerId") String customerId){
		try {
			Customer customer = customerService.getCustomerWithHeadimg(customerId);
			setAttribute("personalCenterVo", weChatService.getPersonalCenterVoWithCustomerUser(customer));
			return "module/weChat/jsp/weChat-personal";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	/**
	 * 跳转至个人中心页面通过微信一级菜单
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping(value="/wcPersonalCenterByMenu",method=RequestMethod.GET)
	public String wcPersonalCenterByMenu(@RequestParam(value="code", required = false) String code,
			@RequestParam(value="state", required = false) String state){
		try {
			User user = new User();
			Customer customer = new Customer();
			user = userService.getUserWithWeChatNum(state);
			if(StringUtils.isNotBlank(code)&&StringUtils.isNotBlank(state)) {
				if(CookieUtil.getCookieByName(getRequest(), "openid"+state)==null){
					customer = customerService.getCustomerWithCodeUser(code, user);
					CookieUtil.addCookie(getResponse(), "openid"+state,  customer.getWeChatNum(), 1000*60*5);
				}else{//用户第二回点击直接，直接使用session中的userId
					String openid=CookieUtil.getCookieByName(getRequest(), "openid"+state).getValue();
					customer = customerService.getCustomerWithWeChatNum(openid, user);
				}
			} 
			
			setAttribute("personalCenterVo", weChatService.getPersonalCenterVoWithCustomerUser(customer));
			return "module/weChat/jsp/weChat-personal";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	
	/**
	 * 跳转至提现单页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcWithdrawCashInput",method=RequestMethod.GET)
	public String wcWithdrawCashInput(@RequestParam(value="customerId") String customerId){
		try {
			setAttribute("customer", customerService.getCustomerWithId(customerId));
			return "module/weChat/jsp/weChat-withdrawCashInput";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 添加提现单
	 */
	@RequestMapping(value="/withdrawCashSave")
	public String withdrawCashSave(@FormModel("model") WithdrawCash withdrawCash){
		try {
			withdrawCashService.save(withdrawCash);
			setAttribute("withdrawCash", withdrawCash);
			return "module/weChat/jsp/weChat-applySuccess";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至我的代理页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/agentList",method=RequestMethod.GET)
	public String agentList(@RequestParam(value="customerId") String customerId){
		try {
			setAttribute("agentList", weChatService.getAgentListWithCustomerId(customerId));
			return "module/weChat/jsp/weChat-agentList";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	/**
	 * 跳转至我的推广页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/promotionList",method=RequestMethod.GET)
	public String promotionList(@RequestParam(value="customerId") String customerId){
		try {
			setAttribute("promotionList", weChatService.getPromotionListWithCustomerId(customerId));
			return "module/weChat/jsp/weChat-promotionList";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至订单管理页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/orderList",method=RequestMethod.GET)
	public String orderList(@RequestParam(value="customerId") String customerId){
		try {
			setAttribute("customerId", customerId);
			/**未支付*/
			List<Order> listUnpayment=new ArrayList<Order>();
			/**未发货*/
			List<Order> listUnsend=new ArrayList<Order>();
			/**已发货*/
			List<Order> listUnreceive=new ArrayList<Order>();
			/**完成*/
			List<Order> listFinish=new ArrayList<Order>();
			
			for(Order order:orderService.getOrderListWithCustomerId(customerId)){
				if(Order.ORDER_STATE_UNPAYMENT.equals(order.getState())){
					listUnpayment.add(order);
				}else if(Order.ORDER_STATE_UNSEND.equals(order.getState())){
					listUnsend.add(order);
				}else if(Order.ORDER_STATE_UNRECEIVE.equals(order.getState())){
					listUnreceive.add(order);
				}
				else if(Order.ORDER_STATE_FINSHED.equals(order.getState())||Order.ORDER_STATE_RECEIVE.equals(order.getState())){
					listFinish.add(order);
				}
			}
			setAttribute("listUnpayment", listUnpayment);
			System.out.println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<listUnreceive:"+listUnreceive.size());
			setAttribute("listUnsend", listUnsend);
			setAttribute("listUnreceive", listUnreceive);
			setAttribute("listFinish", listFinish);
			return "module/weChat/jsp/weChat-orderList";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至商品评价页面
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/appraisalInput",method=RequestMethod.GET)
	public String appraisalInput(@RequestParam(value="customerId") String customerId,
			@RequestParam(value="orderGoodsId") String orderGoodsId){
		try {
			setAttribute("customerId", customerId);
			setAttribute("orderGoods", orderGoodsService.getOrderGoodsWithId(orderGoodsId));
			return "module/weChat/jsp/weChat-appraisalInput";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 保存评价
	 */
	@RequestMapping(value="/doSaveAppraisal",method=RequestMethod.POST)
	public String doSaveAppraisal(@FormModel("evaluation") Evaluation evaluation, @RequestParam(value="orderGoodsId") String orderGoodsId){
		try {
			evaluationService.save(evaluation);
			orderGoodsService.evaluationed(orderGoodsId);
			return orderList(evaluation.getCustomer().getId());
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 确认收货		
	 * @param customerId
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value="/confirmReceipt",method=RequestMethod.GET)
	public String confirmReceipt(@RequestParam(value="customerId") String customerId, @RequestParam(value="orderId") String orderId){
		try {
			orderService.confirmReceipt(orderId);
			return orderList(customerId);
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至推广图片页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcSpread",method=RequestMethod.GET)
	public String wcSpread(@RequestParam(value="code", required = false) String code,
			@RequestParam(value="state", required = false) String state,
			@RequestParam(value="customerId", required = false) String customerId){
		try {
			User user = new User();
			Customer customer = new Customer();
			if(StringUtils.isNotBlank(code)&&StringUtils.isNotBlank(state)) {
				user = userService.getUserWithWeChatNum(state);
				customer = customerService.getCustomerWithCodeUser(code, user);
			} else if(StringUtils.isNotBlank(customerId)){
				customer = customerService.getCustomerWithId(customerId);
			}
			setAttribute("customer", customer);
			setAttribute("qrcodeUrl", weChatService.getQrcodeUrlWithCustomerIdAccessToken(customer));
			return "module/weChat/jsp/weChat-spread";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	/**
	 * 跳转至销售话术页面
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value="/wcPropaganda",method=RequestMethod.GET)
	public String wcPropaganda(@RequestParam(value="code") String code, @RequestParam(value="state") String state){
		try {
			User user = userService.getUserWithWeChatNum(state);
			setAttribute("propagandaList", progagandaService.getPropagandaListWithUser(user));
			return "module/weChat/jsp/weChat-propaganda";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	
	@RequestMapping(value="/paymentTest",method=RequestMethod.GET)
	public void paymentTest(@RequestParam(value="orderId") String orderId){
		try {
			Order order = orderService.getOrderWithId(orderId);
			if(Order.ORDER_STATE_UNPAYMENT.equals(order.getState())) {
				orderService.payment(orderId);
			}
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	
	/**
	 * 从购物车删除
	 */
	@RequestMapping(value="/orderDelete",method=RequestMethod.POST)
	@ResponseBody
	public void orderDelete(@RequestParam(value="id") String id){
		try {
			orderService.deleteOrder(id);
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	
	/**
	 * 初始化菜单
	 */
	@RequestMapping(value="/initMenu",method=RequestMethod.POST)
	@ResponseBody
	public void initMenu(){
		try {
			WeChatUtil.initMenu();
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	
	/**
	 * 初始化菜单
	 */
	@RequestMapping(value="/initMenuById",method=RequestMethod.POST)
	@ResponseBody
	public void initMenuById(String userId){
		try {
			WeChatUtil.initMenuById(userId);
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
		}
	}
	
	@RequestMapping(value="/test",method=RequestMethod.GET)
	public String test(){
		try {
			int a=5/0;
			return "module/weChat/jsp/404";
		} catch (Exception e) {
			MailSendHelper.sendText(e.getClass().getName(),"异常名称："+e.getClass().getName()+"\r\n异常原因："+e.getMessage()+"\r\n出错位置：\r\n"+this.getClass().getName()+getExceptionAllinformation(e));
			return "module/weChat/jsp/404";
		}
	}
	
	
//	/**
//	 * 跳转至代理中心页面
//	 * @param code
//	 * @param state
//	 * @return
//	 */
//	20150706163221943414550884176531
//	20150707101214662806892817833442
//	@RequestMapping(value="/wcAgentCenter",method=RequestMethod.GET)
//	public String wcAgentCenter(@RequestParam(value="code") String code, @RequestParam(value="state") String state){
//		User user = userService.getUserWithWeChatNum(state);
//		Customer customer = customerService.getCustomerWithCodeUser(code, user);
//		
//		
//		customer = customerService.getCustomerWithId("20150512182521980413700959073934");
//		String str = WeChatUtil.httpRequest(RequestUrlUtil.getUserInfoUrl(WeChatUtil.getAccessToken(user), customer.getWeChatNum()), "GET", null);
//		Map<String, String> customerMap = JsonUtil.json2Map(str);
//		customer.setHeadimgurl(customerMap.get("headimgurl"));
//		
//		
//		setAttribute("agentCenterVo", weChatService.getAgentCenterVoWithCustomerUser(customer, user));
//		return "module/weChat/jsp/weChat-agentCenter";
//	}
//	/**
//	 * 跳转至个人中心页面
//	 * @param code
//	 * @param state
//	 * @return
//	 */
//	@RequestMapping(value="/wcPersonalCenter",method=RequestMethod.GET)
//	public String wcPersonalCenter(@RequestParam(value="code") String code, @RequestParam(value="state") String state){
//		User user = userService.getUserWithWeChatNum(state);
//		Customer customer = customerService.getCustomerWithCodeUser(code, user);
//		
//		customer = customerService.getCustomerWithId("20150512182521980413700959073934");
//		String str = WeChatUtil.httpRequest(RequestUrlUtil.getUserInfoUrl(WeChatUtil.getAccessToken(user), customer.getWeChatNum()), "GET", null);
//		Map<String, String> customerMap = JsonUtil.json2Map(str);
//		customer.setHeadimgurl(customerMap.get("headimgurl"));
//		
//		
//		setAttribute("user", user);
//		setAttribute("customer", customer);
//		setAttribute("personalCenterVo", weChatService.getPersonalCenterVoWithCustomerUser(customer, user));
//		return "module/weChat/jsp/weChat-personalCenter";
//	}
	
	public  String getExceptionAllinformation(Exception ex){
        StringBuffer sOut = new StringBuffer();
        StackTraceElement[] trace = ex.getStackTrace();
        for (StackTraceElement s : trace) {
            sOut.append("\tat ").append(s).append("\r\n");
        }
        return sOut.toString();
	}
	
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private WeChatService weChatService;
	@Autowired
	private CustomerService customerService;
	@Autowired
	private UserService userService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private WithdrawCashService withdrawCashService;
	@Autowired
	private PropagandaService progagandaService;
	@Autowired
	private ShoppingCartService shoppingCartService;
	@Autowired
	private EvaluationService evaluationService;
	@Autowired
	private OrderGoodsService orderGoodsService;
	@Autowired
	private FreightService freightService;
	@Autowired
	private TypeService typeService;
	@Autowired
	private AdvertisementService advertisementService;
}