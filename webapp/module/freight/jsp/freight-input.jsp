<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.freight.freightInput");
			com.yunt.freight.input = {
				doInput : function(dialogId) {
					if(!$("#${pageId}theForm").valid()){
						return false;
					}
					/* if(!$.hz.swfupload.validateAttachment("fileDiv")){
						return false;
					} */
					var formData = $("#${pageId}theForm").serialize();
					$.ajax({
					 	type: "POST",
					  	url: "${path}/freight/saveOrUpdate",
					  	data: formData,
					  	success: function(){
					  		$.successTips();
					   		art.dialog.list[dialogId].close();
					   		com.yunt.freight.index.refresh();
					  	}
					});
				}
			};
			$(document).ready(function() {
				$.hz.validate.init("${pageId}theForm");
				/* <c:if test="${empty model.id}">
					$.hz.swfupload.init("fileDiv",{classFieldName:"com.unitever.module.goods.model.Goods,id",required:true});
				</c:if>
				<c:if test="${not empty model.id}">
					$.hz.swfupload.init("fileDiv",{classFieldName:"com.unitever.module.goods.model.Goods,id",idOwner:"${model.id}",required:true});
				</c:if> */
			});
		</script>
	</head>
	<body>
		<form id="${pageId}theForm" method="post" class="BB">
			<input type="hidden" name="model.id" value="${model.id}" />
			<input type="hidden" name="model.userID" value="${model.userID}" />
			<div style="padding: 20px;">
				<div class="pl100 lh50">
			     	<label class="labelTitle"><em style="color: red;">*</em>运费：</label>
			     	<input id="${pageId}freight" name="model.freight" type='text' maxlength="20" class="required" value="${model.freight}" decimal2="true"/>
				</div>
				<div class="pl100 lh50">
			     	<label class="labelTitle"><em style="color: red;">*</em>包邮金额:</label>
			     	<input id="${pageId}limitMoney" name="model.limitMoney" type='text' maxlength="20" class="required" value="${model.limitMoney}" decimal2="true"/>
				</div>
			</div>
		</form>
	</body>
</html>