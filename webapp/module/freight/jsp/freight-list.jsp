<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/platform/common/jsp/taglibs.jsp" %>
<html>
	<head>  
		<script type="text/javascript">
			Namespace.register("com.yunt.freight.list");
		</script>
	</head>
	<body>
		<form id="${pageId}theForm" action="${path}/freight/list">
			<table class="table" cellspacing="0" cellpadding="0">
				 <thead>
			        <tr>
			            <th width="5%">序号</th>
			            <th width="20%">运费</th>
			            <th width="20%">包邮范围</th>
			            <th>操作</th>
			        </tr>
			    </thead>
				<tbody>
					<c:forEach items="${pageObj.results}" var="freight" varStatus="i">
						<c:if test="${i.index%2 eq 0}">
							<tr class="a1">
								<td>${(i.index+1)+((pageObj.pageNo-1) * pageObj.pageSize)}</td>
								<td>${freight.freight}</td>
								<td>${freight.limitMoney}</td>
								<td>
									<input type="button" value="修改" class="btn" onclick="com.yunt.freight.index.input('${path}/freight/input?id=${freight.id}&inputKind=update', '修改');" />
								</td>
							</tr>
						</c:if>
						<c:if test="${i.index%2 ne 0}">
							<tr class="a2">
								<td>${(i.index+1)+((pageObj.pageNo-1) * pageObj.pageSize)}</td>
								<td>${freight.freight}</td>
								<td>${freight.limitMoney}</td>
								<td>
									<input type="button" value="修改" class="btn" onclick="com.yunt.freight.index.input('${path}/freight/input?id=${freight.id}&inputKind=update', '修改');" />
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
