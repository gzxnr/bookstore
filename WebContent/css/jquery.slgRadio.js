(function($){
	$.fn.slgRadio=function(options){
		var r_obj = $(this);
		var r_opts = $.extend($.fn.slgRadio.defaults, options);
		var radios=r_obj.find("input[type='radio']");
		
		return {
			initRadio:function(radioId){//初始化radio（有时候初始化选中一个点击其他的这一个不取消，所以才用这个方法）
			if(r_opts.radioType=='single'){//单选
			   radios.each(function(index){
				   if(radioId!=undefined){
				   if(radioId==$(this).attr("id")){//初始化固定ID的RADIO为选中状态
					   $(this).attr("checked",true);
				   }}
				   else {//如果没有参数的话要将所有radio置为未选择状态
					   $(this).attr("checked",false); 
				   }
				   $(this).click(function(){//给每个radio注册click事件，使得选中该radio后别的都置为未选择
					   $(this).attr("checked",true);
					   radios.each(function(i){
						   if(i!=index){
							   $(this).attr("checked",false);
						   }
					   });
				   });
			   });
			  }
			  if(r_opts.radioType=='multiple'){//多选
				  
			   }
 		    },
 		    getSelectedValues:function(){//得到已选择的radio的值
 		    	var values=[];
 		    	radios.each(function(){
 		    		if($(this).attr("checked")){
 		    			values.push($(this).val());
 		    		}
 		    	});
 		    	return values;
 		    },
 		    setRadio:function(value){//通过后台取出的数据来设置radio的值
 		    	radios.each(function(){
 		    		if($(this).val()==value){
 		    			$(this).attr("checked",true);
 		    		}
 		    	});
 		    }
		};
	}
	$.fn.slgRadio.defaults={
		radioType:'single'
	};
})(jQuery);