<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
<head>
	<meta charset="utf-8">
	<title>提现申请</title>
    <!--适配begin-->
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
    <!--适配end-->
    <link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
    <link href="${path}/module/weChat/css/reflect.css" rel="stylesheet" type="text/css">
    <script src="${path}/module/weChat/js/jquery.js" type="text/javascript"></script>
    <script src="${path}/module/weChat/js/reflect.js" type="text/javascript"></script>
    
<script type="text/javascript">
			function doSave() {
				$("#accountNameTip").hide();
				$("#accountNumTip").hide();
				$("#accountBankTip").hide();
				$("#moneyTip").hide();
				var flag = true;
				if($("#accountName").val().trim()=="") {
					flag = false;
					$("#accountNameTip").show();
				}
				if($("#accountNum").val().trim()=="") {
					flag = false;
					$("#accountNumTip").show();
				}
				if($("#accountBank").val().trim()=="") {
					flag = false;
					$("#accountBankTip").show();
				}
				if($("#money").val().trim()=="") {
					flag = false;
					$("#moneyTip").show();
				}
				if(flag) {
					var money = parseFloat($("#money").val().trim());
					var cash = parseFloat("${customer.remainMoney}");
					if(money<100) {
						alert("低于100元，无法提现");
						return;
					}
					if(money>cash) {
						alert("余额不足");
						return;
					}
					$("#${pageId}theForm").submit();
				}
			}
		</script>
</head>

<body>
<!--内容 begin-->
	<form id="${pageId}theForm" method="post" action="${path}/weChat/withdrawCashSave">
		<input name="model.customer.id" value="${customer.id}" type="hidden">
		<input name="model.user.id" value="${customer.user.id}" type="hidden">
		<div class="shop">
			<label for="" class="">账户姓名：</label>
			<input id="accountName" class="form-control" name="model.accountName" type="text">
			<span id="accountNameTip" class="withdrawCashTip">账户姓名不能为空！</span>
		</div>
		<div class="shop">
			<label for="" class="">账号：</label>
			<input id="accountNum" class="form-control" name="model.accountNum" type="text">
			<span id="accountNumTip" class="withdrawCashTip">账号不能为空！</span>
		</div>
		<div class="shop">
			<label for="" class="">开户银行：</label>
			<input id="accountBank" class="form-control" name="model.accountBank" type="text">
			<span id="accountBankTip" class="withdrawCashTip">开户银行不能为空！</span>
		</div>
		<div class="shop">
			<label for="" class="">提现金额：</label>
			<input id="money" class="form-control" name="model.money" type="text">
			<span id="moneyTip" class="withdrawCashTip">提现金额不能为空！</span>
		</div>
        <!---->
		<!--提现按钮 begin-->
        <!---->
		<a href="javascript:void(0);" onclick="doSave();" class="btn btn-info">提交提现申请</a>
		<p class="tel">温馨提示：您的可提现金额满99元即可提现，我们会在1-7个工作日内处理您的提现申请（节假日除外），如有异议请拨打电话进行查询&nbsp;400-5588-474</p>
	</form>
<!--内容 end-->	
</body>
</html>
