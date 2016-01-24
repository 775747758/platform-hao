<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<title>我的代理</title>
<!--适配begin-->
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<!--适配end-->
<link href="${path}/module/weChat/css/reset.css" rel="stylesheet"
	type="text/css">
<link href="${path}/module/weChat/css/agent.css" rel="stylesheet"
	type="text/css">
</head>

<body>
	<!--user begin-->
	<div class="agent-container">
		<c:forEach items="${agentList}" var="customer">
			<div class="agent">
				<img src="${customer.headimgurl}">
				<p>${customer.name}</p>
			</div>
		</c:forEach>

	</div>
	<!--user end-->
</body>
</html>
