			function submit() {
				$("#accountNameTip").hide();
				$("#accountNumTip").hide();
				$("#accountBankTip").hide();
				$("#moneyTip").hide();
				var flag = true;
				if($("#accountName").val().trim()=="") {
					flag = false;
					$("#accountNameTip").show();
				}
				if($("#accountNum").val().trim()=="") {
					flag = false;
					$("#accountNumTip").show();
				}
				if($("#accountBank").val().trim()=="") {
					flag = false;
					$("#accountBankTip").show();
				}
				if($("#money").val().trim()=="") {
					flag = false;
					$("#moneyTip").show();
				}
				if(flag) {
					$("#page20150616095512441259847569150273theForm").submit();
/* 					var formData = $("#page20150616095512441259847569150273theForm").serialize();
					$.ajax({
					 	type: "POST",
					  	url: "/platform/weChat/withdrawCashSave",
					  	data: formData,
					  	success: function(){
					  		window.location.href="http://www.baidu.com";
					  	}
					});
 */				}
			}
