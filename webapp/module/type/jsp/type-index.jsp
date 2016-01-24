<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.type.index");
			com.yunt.type.index = {
				pageId : "${pageId}",
				loadContent : function(href) {
					$("body").mask("数据正在加载中，请稍后···");
					$("#content").load(href,function(){
						$("body").unmask();
					});
				},
				input : function(href,title) {
					$.dialog.load(href,{
						id: '${pageId}typeInput',
						title:title,
						width:720,
						height:720,
						lock:true,
						ok:function(){
							com.yunt.type.input.doInput('${pageId}typeInput');
							return false;
						},
						cancel: function(){
		
						}
					})
				},
				refresh : function () {
					com.yunt.type.index.loadContent("${path}/type/list?model.name="+$("#${pageId}name").val());
				}
			};
			$(document).ready(function(){
				com.yunt.type.index.refresh();
				var height=$(window).height()-160;
				$(".details").css("height",height);
				
			});
		</script>
	</head>
	<body>
		<div class="cont">
			<div class="title">产品管理</div>
			<div class="details">
				<div class="details_operation clearfix">
						<div class="bui_select">
				    	<img src="${path}/platform/theme/distributionSystem/images/coin.png" class="hand">
						<input type="button" value="添加类别" class="add" onclick="com.yunt.type.index.input('${path}/type/input?inputKind=save', '添加');">
					</div>
				</div>
				<div id="content" />
		    </div>
		</div>
	</body>
</html>