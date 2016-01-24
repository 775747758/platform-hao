<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<title>寻找代理</title>
    <!--适配begin-->
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
    <!--适配end-->
    <link href="${path}/module/weChat/css/reset.css" rel="stylesheet" type="text/css" />
    <style>
		*{ font-size:14px;}
		html{ background-color:#fff;}
		a{ display:block;}
    </style>
</head>

<body>
<!--内容 begin-->
	<div style="width:100%; text-align:center; padding-top:120px; background-image:url(${path}/module/weChat/images/bg03.png); background-size:100; height:960px;">
    	<div style=" color:#50555b; font-size:18px; font-weight:bold;">您还不是代理<br>无法生成推广图片</div>
    	<a href="${path}/weChat/wcGoodsList?customerId=${customerId}" style="background-color:#ff4700; border-radius:2px; padding:4px 0; width:140px; color:#fff; margin:50px auto;">进入商城</a>
    </div>
<!--内容 end-->	
</body>
</html>
