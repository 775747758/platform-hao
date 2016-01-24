<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<title>订单</title>
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
<link href="${path}/module/weChat/css/order.css" type="text/css"
	rel="stylesheet">
<script src="${path}/module/weChat/js/jquery.js" type="text/javascript"></script>
<script type="text/javascript">
	function deleteGoods(orderId) {
		$.ajax({
			type : "POST",
			url : "${path}/weChat/orderDelete?id=" + orderId,
			processData : true,
			success : function() {
				$("#" + orderId + "order").remove();
			}
		});
	};
	function confirmReceipt(orderId) {
		$.ajax({
			type : "GET",
			url : "${path}/weChat/confirmReceipt?orderId=" + orderId+"&customerId=${customerId}",
			processData : true,
			success : function() {
				$("#" + orderId + "order").remove();
			}
		});
	};
	function orderPay(orderId) {
		$.ajax({
			type : "GET",
			url : "${path}/weChat/orderPay?id=" + orderId,
			processData : true,
			success : function() {
				var obj = eval('(' + data + ')');
				if (typeof WeixinJSBridge == "undefined") {
					if (document.addEventListener) {
						document.addEventListener(
								'WeixinJSBridgeReady', onBridgeReady,
								false);
					} else if (document.attachEvent) {
						document.attachEvent('WeixinJSBridgeReady',
								onBridgeReady);
						document.attachEvent('onWeixinJSBridgeReady',
								onBridgeReady);
					}
				} else {
					WeixinJSBridge
							.invoke(
									'getBrandWCPayRequest',
									{
										"appId" : obj.appId, //公众号名称，由商户传入     
										"timeStamp" : obj.timeStamp, //时间戳，自1970年以来的秒数     
										"nonceStr" : obj.nonceStr, //随机串     
										"package" : "prepay_id="
												+ obj.prepayId,
										"signType" : "MD5", //微信签名方式:     
										"paySign" : obj.paySign
									//微信签名 
									},
									function(res) {
										if (res.err_msg == "get_brand_wcpay_request:ok") {
											window.location.href = "${path}/weChat/wcPersonalCenter?customerId=${customerId}";
										} else {
											window.location.href = "${path}/weChat/wcPaymentFail?customerId=${customerId}";
										} // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。 
									});
				}
			}
		});
	};
	
</script>
</head>




<body>
	<!--order begin-->
	<div class="box">
		<ul class="menu">
			<!-- <li class="current">待付款</li> -->
			<li class="current">待发货</li>
			<li class="others">待收货</li>
			<li class="others">已完成</li>
		</ul>
		
		
	<%-- 	<!---->
		<!---->
		<div class="content current" style="margin-bottom:70px;">
			<c:if test="${fn:length(listUnpayment)==0}">
				<img src="${path}/module/weChat/images/order.png"
					class="nothing-img">
				<h3 class="nothing-text">你还没有订单记录哦！</h3>
				<div  class="nothing-go">
					<a href="${path}/weChat/wcGoodsList?customerId=${customerId}">去逛逛</a>
				</div>

			</c:if>
			<div class="list">
				<ul>
					<c:forEach items="${listUnpayment}" var="order">
						<li id="${order.id}order">
							<div class="list-tit-name">
								<h5>订单状态</h5>
								<p>待付款</p>
							</div> <c:forEach items="${order.orderGoodsList}" var="orderGoods">
								<a href="${path}/weChat/wcGoodsView?id=${orderGoods.goods.id}&customerId=${customerId}" >
									<div class="clearfix">
										<img
											src="${path}/platform/images/${orderGoods.goods.picUrls[0]}"
											class="clearfix-img">
										<div>
											<p>${orderGoods.goods.name}</p>
											<p>￥${orderGoods.price}</p>
										</div>
									</div>
								</a>
							</c:forEach>
							<div class="total">
								<p>
									共${order.totalCount}件&nbsp;合计：￥<span>${order.totalPrice}（含运费￥${order.freight}）元</span>
								</p>
							</div>
							<div class="function">
								<a href="javascript:void(0);"
									onclick="deleteGoods('${order.id}')"><p>取消订单</p></a> 
									<a href="javascript:void(0);" onclick="orderPay('${order.id}')"><p
										style="background-color: #FF4700; color: #fff; border: none;">去付款</p></a>
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div> --%>
		<!---->
		<div class="content current" style="display: none;margin-bottom:70px;">
		<c:if test="${fn:length(listUnsend)==0}">
				<img src="${path}/module/weChat/images/order.png"
					class="nothing-img">
				<h3 class="nothing-text">你还没有订单记录哦！</h3>
				<div  class="nothing-go">
					<a href="${path}/weChat/wcGoodsList?customerId=${customerId}">去逛逛</a>
				</div>

			</c:if>
			<div class="list">
				<ul>
					<c:forEach items="${listUnsend}" var="order">
						<li id="${order.id}order">
							<div class="list-tit-name">
								<h5>${order.date}</h5>
								<p>待发货</p>
							</div> <c:forEach items="${order.orderGoodsList}" var="orderGoods">
								<a href="${path}/weChat/wcGoodsView?id=${orderGoods.goods.id}&customerId=${customerId}">
									<div class="clearfix">
										<img
											src="${path}/platform/images/${orderGoods.goods.picUrls[0]}"
											class="clearfix-img">
										<div>
											<p>${orderGoods.goods.name}</p>
											<p>￥${orderGoods.price}</p>
										</div>
									</div>
								</a>
							</c:forEach>
							<div class="total">
								<p>
									共${order.totalCount}件&nbsp;合计：￥<span>${order.totalPrice}（含运费￥${order.freight}）元</span>
								</p>
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<!---->
		<div class="content current" style="display: none;margin-bottom:70px;">
			<c:if test="${fn:length(listUnreceive)==0}">
				<img src="${path}/module/weChat/images/order.png"
					class="nothing-img">
				<h3 class="nothing-text">你还没有订单记录哦！</h3>
				<div  class="nothing-go">
					<a href="${path}/weChat/wcGoodsList?customerId=${customerId}">去逛逛</a>
				</div>

			</c:if>
			<div class="list">
				<ul>
					<c:forEach items="${listUnreceive}" var="order">
						<li id="${order.id}order">
							<div class="list-tit-name">
								<h5>${order.date}</h5>
								<p>待收货</p>
							</div> <c:forEach items="${order.orderGoodsList}" var="orderGoods">
								<a href="${path}/weChat/wcGoodsView?id=${orderGoods.goods.id}&customerId=${customerId}">
									<div class="clearfix">
										<img
											src="${path}/platform/images/${orderGoods.goods.picUrls[0]}"
											class="clearfix-img">
										<div>
											<p>${orderGoods.goods.name}</p>
											<p>￥${orderGoods.price}</p>
										</div>
									</div>
								</a>
							</c:forEach>
							<div class="total">
								<p>
									共${order.totalCount}件&nbsp;合计：￥<span>${order.totalPrice}（含运费￥${order.freight}）元</span>
								</p>
							</div>
							<div class="function">
								<a href="javascript:void(0);"
									onclick="confirmReceipt('${order.id}')" ><p>确认收货</p></a>		
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<!---->
		<div class="content current" style="display: none;margin-bottom:70px;" >
			<c:if test="${fn:length(listFinish)==0}">
				<img src="${path}/module/weChat/images/order.png"
					class="nothing-img">
				<h3 class="nothing-text">你还没有订单记录哦！</h3>
				<div  class="nothing-go">
					<a href="${path}/weChat/wcGoodsList?customerId=${customerId}">去逛逛</a>
				</div>

			</c:if>
			<div class="list">
				<ul>
					<c:forEach items="${listFinish}" var="order">
						<li id="${order.id}order">
							<div class="list-tit-name">
								<h5>${order.date}</h5>
								<p>已完成</p>
							</div> <c:forEach items="${order.orderGoodsList}" var="orderGoods">
								<a href="${path}/weChat/wcGoodsView?id=${orderGoods.goods.id}&customerId=${customerId}">
									<div class="clearfix">
										<img
											src="${path}/platform/images/${orderGoods.goods.picUrls[0]}"
											class="clearfix-img">
										<div>
											<p>${orderGoods.goods.name}</p>
											<p>￥${orderGoods.price}</p>
										</div>
									</div>
								</a>
							</c:forEach>
							<div class="total">
								<p>
									共${order.totalCount}件&nbsp;合计：￥<span>${order.totalPrice}（含运费￥${order.freight}）元</span>
								</p>
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
	</div>
	<script>
		$(function(){
			//alert("length:"+'${fn:length(listUnreceive)}');
			//alert("customerId:"+'${customerId}');
			$(".content").eq(0).fadeIn(200);
		});
		$(".menu li").click(function() {
			$(".menu li").addClass("others");
			$(this).removeClass("others").addClass("current");
			var index = $(".menu li").index(this);
			$(".content").hide();
			$(".content").eq(index).fadeIn(200);
		})
	</script>


	<!--nav begin-->
	<div class="mainNav">
		<a href="${path}/weChat/wcGoodsList?customerId=${customerId}" class="nav-icon"> <img
			src="${path}/module/weChat/images/icon01.png"> <span >商城首页</span>
		</a> <a href="${path}/weChat/shoppingCart?customerId=${customerId}" class="nav-icon"> <img src="${path}/module/weChat/images/icon02.png">
			<span>购物车</span>
		</a> <a href="javascript:void(0);" class="nav-icon"> <img src="${path}/module/weChat/images/icon06.png">
			<span style="color: #00afff;">订单管理</span>
		</a>
	</div>
	<!--nav end-->
</body>
</html>
