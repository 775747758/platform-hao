<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
<head>
	<meta charset="utf-8">
	<title>支付失败</title>
    <!--适配begin-->
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
    <!--适配end-->
    <link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
    <link href="${path}/module/weChat/css/nav.css" type="text/css" rel="stylesheet">
    <link href="${path}/module/weChat/css/order-failure.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
			function submit() {
				window.location.href="${path}/weChat/wcGoodsList?customerId=${customerId}";
			}
		</script>
</head>

<body>
<!--订单状态begin-->
	<div class="order-status"><img src="${path}/module/weChat/images/failure.png"></div>
<!--订单状态end-->   

<!--付款信息begin-->  
    <div class="order-data">
        <div class="order-icon">
            <a href="javascript:void(0);" onclick="submit();">返回商城</a>
        </div>
    </div>
<!--付款信息end-->


<!--客服begin-->    
    <div class="order-service">
    	<P>如有疑问，请您拨打客服热线</P>
        <P class="phone">4000-173-000</P>
    </div>
<!--客服end-->
</body>
</html>
