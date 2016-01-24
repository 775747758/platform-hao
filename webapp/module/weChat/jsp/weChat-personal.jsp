<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<title>个人中心</title>
<!--适配begin-->
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<!--适配end-->
<link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
<link href="${path}/module/weChat/css/user.css" rel="stylesheet" type="text/css">
</head>

<body>
	<!--header begin-->
	<div class="user-container">
		<img src="${personalCenterVo.customer.headimgurl}"  class="user-pho" >
		<p class="nickname">${personalCenterVo.customer.name}</p>
		<c:if test="${personalCenterVo.customer.kind eq '0'}">
			<p class="grade">普通用户</p>
		</c:if>
		<c:if test="${personalCenterVo.customer.kind eq '1'}">
			<p class="grade">会员用户</p>
		</c:if>

		<div class="function">
			<div class="user-list">
				<P class="list-number">${personalCenterVo.myAgentNum}</P>
				<p class="list-tit">我的代理</p>
			</div>
			<div class="user-list-now">
				<P class="list-number">￥${personalCenterVo.customer.commission}</P>
				<p class="list-tit">可提现金额</p>
			</div>
			<div class="user-list">
				<P class="list-number">￥${personalCenterVo.customer.cash}</P>
				<p class="list-tit">已提现金额</p>
			</div>
		</div>
	</div>
	<!--header end-->


	<!---->
	<div class="user-home" style="height:40px">
		<a style="height:40px" href="${path}/weChat/wcWithdrawCashInput?customerId=${personalCenterVo.customer.id}"> <img class="user-icon-left" src="${path}/module/weChat/images/icon13.png">
			<p style="float:left;height:40px" >我要提现</p> <img class="user-icon-right" src="${path}/module/weChat/images/icon-1.png">
		</a>
	</div>
	<!---->

	<!--内容 begin-->
	<div class="user-content">
		<a href="${path}/weChat/agentList?customerId=${personalCenterVo.customer.id}"> <img class="user-icon-left" src="${path}/module/weChat/images/icon11.png">
			<p>我的代理</p> <img class="user-icon-right" src="${path}/module/weChat/images/icon-1.png">
		</a> 
<%-- 		<a href="${path}/weChat/promotionList?customerId=${personalCenterVo.customer.id}"
			style="width: 100%; border-bottom: 1px solid #e9e9e9; overflow: hidden; color: #50555b;">
			<img class="user-icon-left" src="${path}/module/weChat/images/icon10.png">
			<p>我的推广</p> <img class="user-icon-right" src="${path}/module/weChat/images/icon-1.png">
		</a>  --%>
		<a href="${path}/weChat/orderList?customerId=${personalCenterVo.customer.id}" style="width: 100%; overflow: hidden; color: #50555b;">
			<img class="user-icon-left" src="${path}/module/weChat/images/icon12.png">
			<p>我的订单</p> <img class="user-icon-right" src="${path}/module/weChat/images/icon-1.png">
		</a>
	</div>
	<div class="user-home" style="margin-bottom: 70px;">
		<a href="${path}/weChat/wcGoodsList?customerId=${personalCenterVo.customer.id}" style="height:40px"> <img class="user-icon-left" src="${path}/module/weChat/images/icon04.png">
			<p style="float: left;">进入商城</p> <img class="user-icon-right"
			src="${path}/module/weChat/images/icon-1.png">
		</a>
	</div>
	<!--内容 end-->
</body>
</html>
