/**
 * jquery.validate 拓展  作者（邓文杰）
 */

/*
 * 保留两位小数以内的数字
 */
jQuery.validator.addMethod("decimal2", function(value, element) {
		var decimal2 = /^(([1-9][0-9]{1,10})|([1-9]{1,10}\.[0-9]{1,2})|[0-9])$/;
		return this.optional(element) || (decimal2.test(value));
}, "请输入正确的数字（小数点后最多保留两位数字）");

jQuery.validator.addMethod("ennum", function(value, element){
	return this.optional(element) ||/^[a-zA-Z0-9]+$/.test(value);
}, "只能包括英文字母和数字");