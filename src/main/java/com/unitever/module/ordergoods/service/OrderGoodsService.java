package com.unitever.module.ordergoods.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unitever.module.goods.model.Goods;
import com.unitever.module.goods.service.GoodsService;
import com.unitever.module.order.dao.manual.OrderDAO;
import com.unitever.module.order.model.Order;
import com.unitever.module.ordergoods.dao.manual.OrderGoodsDAO;
import com.unitever.module.ordergoods.model.OrderGoods;
import com.unitever.module.shoppingcart.model.ShoppingCart;
import com.unitever.module.shoppingcart.service.ShoppingCartService;
import com.unitever.module.user.model.User;
import com.unitever.module.user.service.UserService;

@Service
@Transactional
public class OrderGoodsService {

	/**
	 * 添加
	 * @param orderGoods
	 */
	public void save(OrderGoods orderGoods) {
		orderGoodsDAO.save(orderGoods);
	}
	
	public List<OrderGoods> getOrderGoodsListWithGoods(Goods goods) {
		return orderGoodsDAO.getOrderGoodsListWithGoodsId(goods.getId());
	}
	
	public void saveWithOrder(Order order) {
		float totalPrice = 0;
		int totalCount = 0;
		List<OrderGoods> list = new ArrayList<OrderGoods>();
		for(ShoppingCart shoppingCart : shoppingCartService.getShoppingCartListWithCustomer(order.getCustomer())) {
			OrderGoods orderGoods = new OrderGoods();
			orderGoods.setOrder(order);
			orderGoods.setCount(shoppingCart.getCount());
			orderGoods.setGoods(shoppingCart.getGoods());
			orderGoods.setState(OrderGoods.ORDERGOODS_STATE_UNEVALUATION);
			/*if(Order.ORDER_KIND_FIRST.equals(order.getKind())) {
				orderGoods.setPrice(shoppingCart.getGoods().getPrice());
			} else {
				User user = userService.getUserWithId(order.getUser().getId());
				orderGoods.setPrice(String.format("%.2f", (Float.parseFloat(shoppingCart.getGoods().getPrice())/100)*Integer.parseInt(user.getDiscount())));
			}*/
			orderGoods.setPrice(shoppingCart.getGoods().getPrice());
			list.add(orderGoods);
			totalCount += Integer.parseInt(orderGoods.getCount());
			totalPrice = totalPrice + (Float.parseFloat(orderGoods.getPrice()) * Integer.parseInt(orderGoods.getCount()));
			orderGoodsDAO.save(orderGoods);
		}
		// 加上运费
		totalPrice = totalPrice+Float.parseFloat(order.getFreight());
		order.setOrderGoodsList(list);
		order.setTotalCount(totalCount);
		order.setTotalPrice(totalPrice);
		orderDAO.update(order);
		
	}
	public OrderGoods getOrderGoodsWithId(String orderGoodsId) {
		OrderGoods orderGoods = orderGoodsDAO.get(orderGoodsId);
		orderGoods.getGoods().setPicUrls(goodsService.getPicUrl(orderGoods.getGoods()));
		return orderGoods;
	}
	public void evaluationed(String orderGoodsId) {
		OrderGoods orderGoods = orderGoodsDAO.get(orderGoodsId);
		orderGoods.setState(OrderGoods.ORDERGOODS_STATE_EVALUATIONED);
		orderGoodsDAO.update(orderGoods);
	}
	
	public List<OrderGoods> getOrderGoodsListWithOrderId(Order order) {
		return orderGoodsDAO.getOrderGoodsListWithOrderId(order.getId());
	}
	
	public void deleteOrderGoods(String id){
		orderGoodsDAO.delete(id);
	}
	@Autowired
	private OrderGoodsDAO orderGoodsDAO;
	@Autowired
	private UserService userService;
	@Autowired
	private ShoppingCartService shoppingCartService;
	@Autowired
	private GoodsService goodsService;
	
	@Autowired
	private OrderDAO orderDAO;
}