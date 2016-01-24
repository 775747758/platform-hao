<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.advertisement.input");
			com.yunt.advertisement.input = {
				doInput : function(dialogId) {
					if(!$("#${pageId}theForm").valid()){
						return false;
					}
					if(!$.hz.swfupload.validateAttachment("fileDiv")){
						return false;
					}
					var formData = $("#${pageId}theForm").serialize();
					$.ajax({
					 	type: "POST",
					  	url: "${path}/advertisement/saveOrUpdate?inputKind=${inputKind}",
					  	data: formData,
					  	success: function(data){
					  		$.successTips();
					   		art.dialog.list[dialogId].close();
					   		com.yunt.advertisement.index.refresh();
					  	}
					});
				}
			};
			$(document).ready(function() {
				$.hz.validate.init("${pageId}theForm");
				<c:if test="${empty model.id}">
					$.hz.swfupload.init("fileDiv",{classFieldName:"com.unitever.module.advertisement.model.Advertisement,id",required:true});
				</c:if>
				<c:if test="${not empty model.id}">
					$.hz.swfupload.init("fileDiv",{classFieldName:"com.unitever.module.advertisement.model.Advertisement,id",idOwner:"${model.id}",required:true});
				</c:if>
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
				<%-- <div class="pl100 lh50">
			     	<label class="labelTitle"><em style="color: red;">*</em>详细信息:</label>
			     	<input type='text' name="model.note" value="${model.note}" maxlength="50" class="required"/>
			     	<uc:UEditor id="editor2" name="model.note" value="${model.note}" style="width:600px;height:300px;"></uc:UEditor>
			     	<textarea class="form-control required" rows="3" name="model.note" maxlength="100" >${model.note}</textarea>
				</div> --%>
				<div class="pl100 pr100">
					<div id="fileDiv"></div>
				</div>
			</div>
		</form>
	</body>
</html>