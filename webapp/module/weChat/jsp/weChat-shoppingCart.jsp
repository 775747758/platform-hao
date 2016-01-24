<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<title>购物车</title>
<!--适配begin-->
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<!--适配end-->
<link href="${path}/module/weChat/css/reset.css" rel="stylesheet"
	type="text/css" />
<link href="${path}/module/weChat/css/nav.css" type="text/css"
	rel="stylesheet">
<link href="${path}/module/weChat/css/cart.css" type="text/css"
	rel="stylesheet">
<script src="${path}/platform/common/js/jquery-1.11.1.js"></script>
<script type="text/javascript">
	//加法函数，用来得到精确的加法结果
	//说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
	//调用：accAdd(arg1,arg2)
	//返回值：arg1加上arg2的精确结果
	function accAdd(arg1, arg2) {
		var r1, r2, m;
		try {
			r1 = arg1.toString().split(".")[1].length;
		} catch (e) {
			r1 = 0;
		}
		try {
			r2 = arg2.toString().split(".")[1].length;
		} catch (e) {
			r2 = 0;
		}
		m = Math.pow(10, Math.max(r1, r2));
		return (arg1 * m + arg2 * m) / m;
	}
	//减法函数
	function accSub(arg1, arg2)
	{
		var r1, r2, m, n;
		try {
			r1 = arg1.toString().split(".")[1].length;
		} catch (e) {
			r1 = 0;
		}
		try {
			r2 = arg2.toString().split(".")[1].length;
		} catch (e) {
			r2 = 0;
		}
		m = Math.pow(10, Math.max(r1, r2));
		//动态控制精度长度
		n = (r1 >= r2) ? r1 : r2;
		//从网上直接拷贝过来发现有点bug，有的时候会变成负数，所以只要发现是负数，就变成正数
		if(((arg2 * m - arg1 * m) / m).toFixed(n)<0){
			return -(((arg2 * m - arg1 * m) / m).toFixed(n));
		}
		return ((arg2 * m - arg1 * m) / m).toFixed(n);
	}

	function minus(shoppingCartId, price) {

		var count = $("#" + shoppingCartId + "count").val();

		if (count > 1) {
			$("#" + shoppingCartId + "count").val(--count);
			var totalCount = $("#totalCount").val();
			$("#totalCount").val(--totalCount);
			var totalPrice = $("#totalPrice").val();
			//$("#totalPrice").val(parseFloat(totalPrice)-parseFloat(price)+".00");
			$("#totalPrice").val(accSub(parseFloat(totalPrice), parseFloat(price)));
		}
	};
	function plus(shoppingCartId, price) {
		var count = $("#" + shoppingCartId + "count").val();
		$("#" + shoppingCartId + "count").val(++count);
		var totalCount = $("#totalCount").val();
		$("#totalCount").val(++totalCount);
		var totalPrice = $("#totalPrice").val();
		//$("#totalPrice").val(parseFloat(totalPrice)+parseFloat(price)+".00");
		$("#totalPrice").val(accAdd(parseFloat(totalPrice), parseFloat(price)));
	};
	function deleteGoods(shoppingCartId, price) {
		$.ajax({
			type : "POST",
			url : "${path}/weChat/shoppingCartDelete?id=" + shoppingCartId,
			processData : true,
			success : function() {
				var count = $("#" + shoppingCartId + "count").val();
				var totalCount = $("#totalCount").val();
				$("#totalCount").val(parseInt(totalCount) - parseInt(count));
				var totalPrice = $("#totalPrice").val();
				$("#totalPrice")
						.val(
								parseFloat(totalPrice)
										- (parseFloat(price) * parseInt(count))
										+ ".00");
				$("#" + shoppingCartId + "goodsDetail").remove();
			}
		});
	};
	function submitform() {
		if(parseInt('${shoppingCartVo.count}')>0){
			$("#form").submit();
		}else{
			alert("购物车为空");
		}
	};
</script>
</head>


<body>
	<!--cart begin-->
	<section>
		<div class="shopping-cart" style="margin-bottom:100px;" id="ds_gal">
			<!--顶部begin-->
			<div class="top clearfix">
				<div class="pro-num">
					<p>共${shoppingCartVo.count}件商品</p>
				</div>
				<a class="continue" href="${path}/weChat/wcGoodsList?customerId=${shoppingCartVo.customer.id}">继续购物>></a>
			</div>
			<!--顶部end-->

			<form id="form" action="${path}/weChat/wcOrderInput"
				method="post">
				<input type="hidden" name="customerId"
					value="${shoppingCartVo.customer.id}" /> <input type="hidden"
					name="shoppingCartIds" value="${shoppingCartVo.shoppingCartIds}">

				<!--商品列表begin-->
				<div class="list">
					<ul>
						<c:forEach items="${shoppingCartVo.shoppingCartList}"
							var="shoppingCart" varStatus="i">
							<li id="${shoppingCart.id}goodsDetail" class="clearfix first">
								<div class="container clearfix">
									<div class="show clearfix">
										<a><img
											src="${path}/platform/images/${shoppingCart.goods.picUrls[0]}" /></a>
									</div>
									<div class="info">
										<p class="name">
											<a href="goods.html">${shoppingCart.goods.name}</a>
										</p>
										<p class="price">
											本店价<strong>￥${shoppingCart.goods.price}</strong>
										</p>
										<div class="num num-edit clearfix">
											<p>数&nbsp;&nbsp;&nbsp;量</p>
											<!--  普通商品可修改数量 -->
											<div>
												<input
													onclick="minus('${shoppingCart.id}','${shoppingCart.goods.price}')"
													class="edit" type="button" value="-" />
											</div>
											<div>
												<input type="text" class="number"
													name="${shoppingCart.id }countName"
													id="${shoppingCart.id }count"
													value="${shoppingCart.count }" readonly="readonly" />
											</div>
											<div>
												<input
													onclick="plus('${shoppingCart.id}','${shoppingCart.goods.price}')"
													class="edit" type="button" value="+" />
											</div>
										</div>
										<input type="hidden" name='rowid'
											value="a239d26ca5967a553b6db6489b378e17" />
									</div>
								</div> <img  src="${path}/module/weChat/images/trash.png" class="trash" onclick="deleteGoods('${shoppingCart.id}', '${shoppingCart.goods.price}')"> </a>
							</li>
						</c:forEach>

					</ul>
				</div>
				<!--商品列表end-->
				<!--去付款 begin-->
				<div class="item-settlement" style="z-index:1001;">
					<div class="item-information">
						<div class="total-price">
							合计&nbsp; <span class="item-price">￥<input id="totalPrice"
								type="text" value="${shoppingCartVo.originalPrice}"
								class="number" readonly="readonly" style="border: none;"></span>
						</div>
					</div>
					<div class="item-information" >
						<a href="javascript:void(0);" class="clearing" onclick="submitform();">结算</a>
					</div>
					<!--去付款 end-->
			</form>
	</section>
	<!--cart end-->

	<!--nav begin-->
	<div class="mainNav" style="z-index:1000;">
		<a
			href="${path}/weChat/wcGoodsList?customerId=${shoppingCartVo.customer.id}"
			class="nav-icon">
			<img
			src="${path}/module/weChat/images/icon01.png">
			<span >商城首页</span>
		</a> <a href="javascript:void(0);" class="nav-icon"> <img
			src="${path}/module/weChat/images/icon05.png"> <span style="color: #00afff;">购物车</span>
		</a> <a href="${path}/weChat/orderList?customerId=${shoppingCartVo.customer.id}" class="nav-icon"> <img
			src="${path}/module/weChat/images/icon03.png"> <span>订单管理</span>
		</a>
	</div>
	<!--nav end-->
</body>
</html>