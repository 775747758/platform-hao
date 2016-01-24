<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.type.input");
			com.yunt.type.input = {
				doInput : function(dialogId) {
					if(!$("#${pageId}theForm").valid()){
						return false;
					}
					var formData = $("#${pageId}theForm").serialize();
					$.ajax({
					 	type: "POST",
					  	url: "${path}/type/saveOrUpdate?inputKind=${inputKind}",
					  	data: formData,
					  	success: function(data){
					  		if(data=='success'){
					  			$.successTips();
						   		art.dialog.list[dialogId].close();
						   		com.yunt.type.index.refresh();
					  		}else{
					  			$.dialog.alert("提醒：最多添加5个分类！");
					  			art.dialog.list[dialogId].close();
						   		com.yunt.type.index.refresh();
					  		}
					  	}
					});
				}
			};
			$(document).ready(function() {
				$.hz.validate.init("${pageId}theForm");
			});
		</script>
	</head>
	<body>
		<form id="${pageId}theForm" method="post" class="BB">
			<div style="padding: 10px;">
				<c:if test="${inputKind eq 'update'}">
					<input type="hidden" name="model.id" value="${model.id}" />
					<input type="hidden" name="user.id" value="${user.id}" />
				</c:if>
				 <div class="pl100 lh50">
			     	<label class="labelTitle"><em style="color: red;">*</em>名称：</label>
			     	<input id="${pageId}name" name="model.name" type='text' maxlength="10" class="required" value="${model.name}"/>
				</div>
			</div>
		</form>
	</body>
</html>