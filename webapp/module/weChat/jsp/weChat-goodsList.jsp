<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<title>商城</title>
<!--适配begin-->
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<!--适配end-->
<link href="${path}/module/weChat/css/reset.css" type="text/css" rel="stylesheet">
<link href="${path}/module/weChat/css/nav.css" type="text/css" rel="stylesheet">
<link href="${path}/module/weChat/css/mall2.css" type="text/css" rel="stylesheet">
<script src="${path}/module/weChat/js/TouchSlide.1.1.js" type="text/javascript"></script>
</head>

<body>
	<!--banner begin-->
	<div id="viewport" class="viewport">
		<div class="slider card card-nomb" style="visibility: visible;">
			<div id="focus" class="focus">
				<div class="hd">
					<ul></ul>
				</div>
				<div class="bd">
					<ul>
						<c:if test="${empty advertisement }">
							<li><a href="javascript:void(0);" title=""> <img name="ad_img" src="${path}/module/weChat/images/banner2.jpg" alt="" />
							</a></li>
						</c:if>
						<c:if test="${not empty advertisement }">
							<c:forEach items="${advertisement.picUrls }" var="picUrl">
								<li><a href="javascript:void(0);" title=""> <img name="ad_img" src="${path}/platform/images/${picUrl}" alt="" />
								</a></li>
							</c:forEach>
						</c:if>

						<%-- <li><a href="javascript:void(0);" title="" > <img
								name="ad_img" src="${path}/module/weChat/images/banner1.jpg"
								alt="" />
						</a></li>
						<li><a href="javascript:void(0);" title="" > <img
								name="ad_img" src="${path}/module/weChat/images/banner2.jpg"
								alt="" />
						</a></li> --%>
					</ul>
				</div>
			</div>
			<script type="text/javascript">
				TouchSlide({
					slideCell : "#focus",
					titCell : ".hd ul", //开启自动分页 autoPage:true ，此时设置 titCell 为导航元素包裹层
					mainCell : ".bd ul",
					delayTime : 600,
					interTime : 4000,
					effect : "leftLoop",
					autoPlay : true,//自动播放
					autoPage : true, //自动分页
					switchLoad : "_src" //切换加载，真实图片路径为"_src" 
				});
			</script>
		</div>
	</div>

	<!--icon begin-->
	<div class="mall-icon">
		<ul>
			<c:if test="${user.id eq 00000000000000000000000000000004}">
				<c:forEach items="${typeList }" var="type">
				<li><a href="${path}/weChat/wcGoodsList?customerId=${customer.id}&typeId=${type.id}"> <img src="${path}/module/weChat/images/icon-tea.png">
					<p style="font-weight:bold;">${type.name }</p>
			</a></li>
			</c:forEach>
			<li><a href="${path}/weChat/wcGoodsList?customerId=${customer.id}"> <img src="${path}/module/weChat/images/icon-tea.png">
					<p style="font-weight:bold;">全部商品</p>
			</a></li>
			</c:if>
			<c:if test="${user.id ne 00000000000000000000000000000004}">
				<c:forEach items="${typeList }" var="type">
				<li><a href="${path}/weChat/wcGoodsList?customerId=${customer.id}&typeId=${type.id}"> <img src="${path}/module/weChat/images/icon07.png">
					<p style="font-weight:bold;">${type.name }</p>
			</a></li>
			</c:forEach>
			<li><a href="${path}/weChat/wcGoodsList?customerId=${customer.id}"> <img src="${path}/module/weChat/images/icon07.png">
					<p style="font-weight:bold;">全部商品</p>
			</a></li>
			</c:if>
		</ul>
		
	</div>
	<!--icon end-->

	<!--信息提示 begin-->
	<div class="prompt">
		<img src="${path}/module/weChat/images/icon09.png">
		<p>公告：我们的邮费是${freight}元,满${limitMoney}元包邮哦！</p>
	</div>
	<!--信息提示 end-->

	<!--店铺begin-->
	<div class="shop-tit">${typeName }</div>
	<div class="left-list">
		<c:forEach items="${goodsList}" var="goods">
			<div style="float: left; width: 48%; padding-left: 2%;">
				<a href="${path}/weChat/wcGoodsView?id=${goods.id}&customerId=${customer.id}"> <img src="${path}/platform/images/${goods.picUrls[0]}" class="left-pic">
					<div class="shop-name">${goods.name}</div>
					<div class="shop-message">
						<span class="shop-money">￥${goods.price}/${goods.size}</span>
					</div>
				</a>
			</div>
		</c:forEach>



	</div>
	<!--店铺end-->


	<!--nav begin-->
	<div class="mainNav">
		<a href="javascript:void(0);" class="nav-icon"> <img src="${path}/module/weChat/images/icon04.png"> <span style="color: #00afff;">商城首页</span>
		</a> <a href="${path}/weChat/shoppingCart?customerId=${customer.id}" class="nav-icon"> <img src="${path}/module/weChat/images/icon02.png"> <span>购物车</span>
		</a> <a href="${path}/weChat/orderList?customerId=${customer.id}" class="nav-icon"> <img src="${path}/module/weChat/images/icon03.png"> <span>订单管理</span>
		</a>
	</div>
	<!--nav end-->
</body>
</html>
