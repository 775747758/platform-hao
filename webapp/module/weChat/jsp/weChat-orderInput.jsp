<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<script src="${path}/platform/common/js/jquery-1.11.1.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
	<meta charset="utf-8">
	<title>结算中心</title>
    <!--适配begin-->
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
    <!--适配end-->
    <link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
    <link href="${path}/module/weChat/css/pay.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function doSave() {
		var receiver = $("#receiver").val();
		var receiverPhoneNum = $("#receiverPhoneNum").val();
		var receiveAddress = $("#receiveAddress").val();
		
		var reg = new RegExp("^[0-9]{7,11}$");
		if(receiver.trim()=="") {
			alert("收货人不能为空！");
			return;
		} else if (receiverPhoneNum.trim()=="") {
			alert("手机号码不能为空！");
			return;
		} else if(!reg.test(receiverPhoneNum.trim())){
			alert("电话号码应为7到11位数字！");
			return;
		} else if(receiveAddress.trim()=="") {
			alert("收货地址不能为空！");
			return;
		} else if(receiveAddress.trim().length>150){
			alert("收货地址长度不能超过150个字符！");
			return;
		}
		$("#pay").html("正在加载中...");
		$("#pay").removeAttr('onclick');
		$.ajax({
					type : "GET",
					url : "${path}/weChat/orderSave?customerId=${shoppingCartVo.customer.id}&receiver="
							+ encodeURI(encodeURI(receiver))
							+ "&receiverPhoneNum="
							+ encodeURI(encodeURI(receiverPhoneNum))
							+ "&freight="
							+ encodeURI(encodeURI('${freight}'))
							+ "&receiveAddress="
							+ encodeURI(encodeURI(receiveAddress)),
					processData : true,
					success : function(data) {
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
													window.location.href = "${path}/weChat/wcPersonalCenter?customerId=${shoppingCartVo.customer.id}";
												} else {
													window.location.href = "${path}/weChat/wcPaymentFail?customerId=${shoppingCartVo.customer.id}";
												} // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。 
											});
						}
					}
				});
	}
</script>
</head>

<body>
<!--收货地址 begin-->
	<div class="shipping-address">
 		<div class="address-header">收货信息：</div>
     	<div class="contacts">收货人<input type="text" id="receiver" class="shoping-text">${shoppingCartVo.customer.realName}</div>
    	<div class="contacts">手机号码<input type="text" id="receiverPhoneNum" class="shoping-text">${shoppingCartVo.customer.phone}</div>
     	<div class="contacts">详细地址<input type="text" id="receiveAddress" class="shoping-text">${shoppingCartVo.customer.address}</div>
 	</div>
<!--收货地址 end-->


<!--商品信息 begin-->
	<div class="pay-container" style="background-color:#fff; width:100%; margin:6px 0; overflow:hidden; border-top:1px solid #e9e9e9; border-bottom:75px solid #e9e9e9;">
    	<h5 style="color:#50555b; margin-left:6px;line-height:30px; ">订单</h5>
    	<c:forEach items="${shoppingCartVo.shoppingCartList}" var="shoppingCart">
			<div class="container clearfix" style="background-color:#f2f2f2;padding:10px 6px;">
         	<img src="${path}/platform/images/${shoppingCart.goods.picUrls[0]}" style="width:80px; height:60px; float:left; margin-right:6px;">
        	<div class="info">
             	<p class="name">
                	<a >${shoppingCart.goods.name}</a>
               	</p>
              	<p class="price">本店价<strong>￥${shoppingCart.goods.price}</strong></p>
              	<div class="num num-edit clearfix">x${shoppingCart.count}</div>
         	</div>
     	</div>
		</c:forEach>
    </div>
<!--商品信息 end-->


<!--确认订单 begin-->
	<div class="item-settlement" style=" width:100%; padding:0 3%; position:fixed;bottom:0px;background-color:#fff;overflow:hidden;">
		<div class="item-information">
			<div class="total-price">合计&nbsp;
	          	<span class="item-price">￥${totalPrice}</span>
          	</div>
	      	<div class="item-quantity">含运费￥${freight }</div>
	 	</div>
	 	<a id='pay' href="javascript:void(0);" class="clearing" onclick="doSave();">结算</a>
	</div>
<!--确认订单 end-->
</body>
</html>
