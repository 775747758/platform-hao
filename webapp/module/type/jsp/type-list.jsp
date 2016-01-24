<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp"%>
<html>
<head>
<script type="text/javascript">
	Namespace.register("com.yunt.type.list");
	com.yunt.type.list = {
		doDelete : function(id) {
			confirm("确定要删除吗？", function() {
				$.ajax({
					type : "POST",
					url : "${path}/type/doDelete?id=" + id,
					processData : true,
					success : function(data) {
						com.yunt.type.index.refresh();
					}
				});
			});
		}
	};
</script>
</head>
<body>
	<form id="${pageId}theForm" action="${path}/type/list?model.name=${model.name}">
		<!--表格-->
		<table class="table" cellspacing="0" cellpadding="0">
			<thead>
				<tr>
					<th width="5%">编号</th>
					<th width="50%">名称</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${pageObj.results}" var="type" varStatus="i">
					<c:if test="${i.index%2 eq 0}">
						<tr class="a1">
							<td>${(i.index+1)+((pageObj.pageNo-1) * pageObj.pageSize)}</td>
							<td>${type.name}</td>
							<td><input type="button" value="修改" class="btn" onclick="com.yunt.type.index.input('${path}/type/input?id=${type.id}&inputKind=update', '修改');"> 
							 <input type="button" value="删除" class="btn" onclick="com.yunt.type.list.doDelete('${type.id}');"> 
							</td>
						</tr>
					</c:if>
					<c:if test="${i.index%2 ne 0}">
						<tr class="a2">
							<td>${(i.index+1)+((pageObj.pageNo-1) * pageObj.pageSize)}</td>
							<td>${type.name}</td>
							<td><input type="button" value="修改" class="btn" onclick="com.yunt.type.index.input('${path}/type/input?id=${type.id}&inputKind=update', '修改');"> 
							<input type="button" value="删除" class="btn" onclick="com.yunt.type.list.doDelete('${type.id}');">
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
		<uc:pageBar pageInfo="${pageObj.info}" containerId="content" formId="${pageId}theForm" changePageSize="true" changePageSizeNumber="10,20,30" />
	</form>
</body>
</html>