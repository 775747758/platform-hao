<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.freight.index");
			com.yunt.freight.index = {
				loadContent : function(href) {
					$("body").mask("数据正在加载中，请稍后···");
					$("#content").load(href,function(){
						$("body").unmask();
					});
				},
				input : function(href, title) {
					$.dialog.load(href,{
						id: '${pageId}freightInput',
						title:title,
						width:700,
						height:500,
						ok:function(){
							com.yunt.freight.input.doInput('${pageId}freightInput');
							return false;
						},
						cancel: function(){
		
						}
					});
				},
				refresh : function () {
					com.yunt.freight.index.loadContent("${path}/freight/list");
				}
			};
			$(document).ready(function(){
				com.yunt.freight.index.refresh();
				var height=$(window).height()-160;
				$(".details").css("height",height);
			});
		</script>
	</head>
	<body>
		<div class="cont">
			<div class="title">运费管理</div>
			<div class="details">
				<div class="details_operation clearfix">
				</div>
				<div id="content" />
		    </div>
		</div>
	</body>
</html>
