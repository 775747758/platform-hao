<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>商品详情</title>
<!--适配begin-->
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<!--适配end-->
<link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
<link href="${path}/module/weChat/css/product.css" rel="stylesheet" type="text/css">
<script src="${path}/module/weChat/js/jquery.js" type="text/javascript"></script>
<script src="${path}/module/weChat/js/TouchSlide.1.1.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
	function addShoppingCart() {
		$
				.ajax({
					type : "POST",
					url : "${path}/weChat/addShoppingCart?goodsId=${model.id}&customerId=${customerId}",
					processData : true,
					success : function() {
						$("#successTip").fadeIn(500, function() {
							setTimeout(function() {
								$("#successTip").fadeOut(500);
							}, 1000);
						});
					}
				});
	};
	function buyNow() {
		$
				.ajax({
					type : "POST",
					url : "${path}/weChat/addShoppingCart?goodsId=${model.id}&customerId=${customerId}",
					processData : true,
					success : function() {
						window.location.href = "${path}/weChat/shoppingCart?customerId=${customerId}";
					}
				});
	};
	window.onload = function() {
		var titles = $(".notice-tit li");
		var divs = $(".notice-con div");
		//遍历titles下的所有lionmouseover
		for (var i = 0; i < titles.length; i++) {
			titles[i].id = i;
			titles[i].onclick = function() {
				//清除所有li上的class
				for (var j = 0; j < titles.length; j++) {
					titles[j].className = '';
					divs[j].style.display = 'none';
				}
				//设置当前为高亮显示
				this.className = 'select';
				divs[this.id].style.display = 'block';
			}
		}
	}
</script>

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
						<c:if test="${not empty model.picUrls[1]}">
							<li><a href="javascript:void(0);" title=""> <img name="ad_img" src="${path}/platform/images/${model.picUrls[1]}" alt="" />
							</a></li>
						</c:if>
						<c:if test="${not empty model.picUrls[2]}">
							<li><a href="javascript:void(0);" title=""> <img name="ad_img" src="${path}/platform/images/${model.picUrls[2]}" alt="" />
							</a></li>
						</c:if>
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
	<!--banner end-->


	<!--产品信息 begin-->
	<div style="background-color: #fff; border-bottom: 1px solid #e9e9e9; margin-bottom: 6px; width: 97%; padding: 6px 4px; line-height: 30px;">
		<div style="font-weight: bold;">${model.name}</div>
		<p style="color: #EF0408; font-size: 16px;">
			<span style="font-size: 12px;">￥</span>${model.price}/${model.size}<span style="text-decoration: line-through; color: #D3D3D3; font-size: 12px; padding-left: 6px;">￥${model.originalPrice}</span>
		</p>
		<div style="overflow: hidden; text-align: center; border-top: 1px solid #e9e9e9; color: #9c9c9c;">
			<div style="float: left; width: 32%; font-size: 12px;">邮费：${freight}元</div>
			<div style="float: left; width: 32%; font-size: 12px;">销量：${model.totalCount}笔</div>
			<div style="float: left; width: 32%; font-size: 12px;">内蒙古包头市</div>
		</div>
	</div>
	<!--产品信息 end-->


	<!--内容 begin-->
	<div class="box" style="margin-bottom: 70px;">
		<ul class="menu">
			<li class="current">商品详情</li>
			<li class="others">评价</li>
		</ul>
		<!---->
		<!---->
		<div class="content current">
			<div class="list">
				<ul>
					<c:forEach items="${model.picUrls}" var="picUrl" begin="3">
						<li class='photo'><img src="${path}/platform/images/${picUrl}"></li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<!---->
		<div class="content current" style="display: none">
			<div class="list">
				<ul>
					<c:forEach items="${evaluationList}" var="evaluation">
						<li class="comment-container"><img src="${path}/platform/theme/distributionSystem/images/avatar.jpg" class="comment-pho">
							<div class="comment-content">
								<p class="comment-tit">
									<span class="comment-name">${evaluation.customer.name}</span> <span class="comment-time">${evaluation.ft}</span>
								</p>
								<p class="coment-text">${evaluation.content}</p>
								<p class="comment-product">${evaluation.goods.name}</p>
							</div></li>
					</c:forEach>

				</ul>
			</div>
		</div>
	</div>
	<script>
		$(".menu li").click(function() {
			$(".menu li").addClass("others");
			$(this).removeClass("others").addClass("current");
			var index = $(".menu li").index(this);
			$(".content").hide();
			$(".content").eq(index).fadeIn(200);
		})
	</script>
	<!--内容 end-->


	<!--购买 begin-->
	<div class="buy-now">
		<a href="${path}/weChat/wcGoodsList?customerId=${customerId}" class="home"> <img src="${path}/module/weChat/images/icon01.png"> <span>店铺</span>
		</a> <a href="javascript:void(0);" class="now-car" onclick="addShoppingCart();"> <img src="${path}/module/weChat/images/car.png"> <span class="cart-icon">加入购物车</span>
		</a> <a href="javascript:void(0);" onclick="buyNow();" class="buy-button">立即购买</a>
	</div>

	<div id="successTip" style="background-color: #000; width: 40%; line-height: 60px; position: absolute; left: 30%; top: 40%; opacity: 0.5; text-align: center; border-radius: 5px; font-size: 22px; color: #F99000; display: none;">添加成功</div>
	<!--购买 end-->


	<!--选择 begin-->
	<!--<div>
    	<div>
        	<img src="">
            <div>
            	<p>商品名称</p>
                <p>￥50.00</p>
            </div>
            <img src="">
        </div>
        <div>
        	
        </div>
    </div>-->
	<!--选择 end-->
</body>
</html>
