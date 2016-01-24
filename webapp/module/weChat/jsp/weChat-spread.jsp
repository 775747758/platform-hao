<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>
		<meta name="viewport" content="width=320,user-scalable=no,target-densitydpi=medium-dpi" />
		<meta name="viewport" content="width=device-width,user-scalable=no,target-densitydpi=medium-dpi" />
		<link href="${path}/platform/theme/default/component/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet">
		<link href="${path}/platform/theme/distributionSystem/css/spread.css" type="text/css" rel="stylesheet">
		<script src="${path}/platform/common/js/jweixin-1.js"></script>
		<title>扫描二维码，成为代理商！</title>
		<script type="text/javascript">
			/* window.onload=function(){
				var obj=eval('(${jsApiData})');
				wx.config({
				     debug: false,
				     appId: obj.appId,
				     timestamp: obj.timeStamp,
				     nonceStr: obj.nonceStr,
				     signature: obj.signature,
				     jsApiList: [
				       'checkJsApi',
				       'onMenuShareTimeline',
				       'onMenuShareAppMessage',
				       'onMenuShareQQ',
				       'onMenuShareWeibo',
				       'hideMenuItems',
				       'showMenuItems',
				       'hideAllNonBaseMenuItem',
				       'showAllNonBaseMenuItem',
				       'translateVoice',
				       'startRecord',
				       'stopRecord',
				       'onRecordEnd',
				       'playVoice',
				       'pauseVoice',
				       'stopVoice',
				       'uploadVoice',
				       'downloadVoice',
				       'chooseImage',
				       'previewImage',
				       'uploadImage',
				       'downloadImage',
				       'getNetworkType',
				       'openLocation',
				       'getLocation',
				       'hideOptionMenu',
				       'showOptionMenu',
				       'closeWindow',
				       'scanQRCode',
				       'chooseWXPay',
				       'openProductSpecificView',
				       'addCard',
				       'chooseCard',
				       'openCard'
					]
			 	});
			};
			wx.ready(function(){
				 wx.hideOptionMenu({
				      success: function (res) {
				    	  wx.showMenuItems({
						      menuList: [
						        'menuItem:share:appMessage', // 阅读模式
						        'menuItem:share:timeline', // 分享到朋友圈
						        'menuItem:share:qq',
						        'menuItem:favorite'// 复制链接
						      ],
						      success: function (res) {
						    	  
						      },
						      fail: function (res) {
						    	  alert(1);
						      }
						    });
				      },
				      fail: function (res) {
				    	  alert(2);
				      }
				    });
			}); */
		</script>
	</head>
	<body>     
        <div class="spread-container">
        	<div class="spread-header">
            	<img src="${customer.headimgurl}" class="spread-photo">
                <div style="font-size:18px;font-weight: 600;">${customer.name}</div>
            </div>
            <div class="spread-main">
            	<div>长按二维码关注公众号即可获得代理机会</div>
                <img src="${qrcodeUrl}" class="spread-code">
            </div>
        </div>
        <div>
        	<h4 style="text-align:center; font-size:16px;">分销特权</h4>
            <p style=" margin:0 10px;">1、<strong>独立微商城</strong>（拥有自己的微商城及推广二维码）<br>2、<strong>销售拿佣金</strong>（微商城卖出商品，您可以获得佣金）<br>3、<strong>推广赚佣金</strong>（全店商品均可享受分佣，推广客户终身受益）<br>4、<strong>0成本投入，真正的0元创业</strong>（无需开店，无需囤货，无需投入时间）</p>
            <p style=" margin:10px 10px 0;"><strong>分销商的商品销售统一由厂家直接收款、直接发货，并提供产品的售后服务，分销佣金由厂家统一设置。</strong></p>
        </div>
	</body>
</html>