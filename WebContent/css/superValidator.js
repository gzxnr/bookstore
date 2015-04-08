//***********************************************************
//根据原有验证框架进行改进
//使用时候需要给要增加验证的标签增加check属性
//当check="1"的时候,允许录入为空,如果输入数据就按reg属性绑定的正则表达进行验证.(可以不填，但是填就必须填对)
//当check="2"的时候,就直接按照reg绑定的正则表达式进行验证.

//***********************************************************
//获得所有需要验证的标签
/*(function($){
	$(document).ready(function(){
		$('select[tip],select[check],input[tip],input[check],textarea[tip],textarea[check]').tooltip();
	});
})(jQuery);*/

(function($) {
    $.fn.tooltip = function(options){
		var getthis = this;
        var opts = $.extend({}, $.fn.tooltip.defaults, options);
		//创建提示框
        var tipTable='<table id="tipTable" class="tableTip"><tr><td  class="leftImage"></td> <td class="contenImage" align="left"></td> <td class="rightImage"></td></tr></table>';
        $('body').append(tipTable);
		//移动鼠标隐藏刚创建的提示框
        $(document).mouseout(function(){$('#tipTable').hide()});
        
        
  /*      一个多组Input相互限制验证的部分
        
        function ifIn(arr,x){//判断是否在数组中
        	var sig=false;
        	$(arr).each(function(){
        		if($(this).attr("group")==$(x).attr("group")&&$(this).attr("group")!=null)
        		sig=true;	
        	});
        	return sig;
        }
        
        function getSame(arr,x){
        	var objs=[];
        	$(arr).each(function(){
        		if($(this).attr("group")==$(x).attr("group")&&$(x).attr("group")!=null)
        		objs.push(this);	
        	});
        	return objs;
        }
		
        var xArray=this;
        var groups=[];//用来装最后的分组信息（有重复！但不影响结果）
        var temp=[];
        temp.push("-1");
        for(var i=0;i<xArray.length;i++){
        	if(ifIn(temp,xArray[i])){//xArray[i]为那个有重复的东西
        		//将xArray[i]抓出来与所有的内容比对，并且抓出所有的一样group的信息
        		var objs=getSame(xArray,xArray[i]);//这些OBJS组中有重复内容
        		console.log(objs.length);
        		$(objs).each(function(){
        			//console.log($(this).attr("id"));
        		});
        		groups.push(objs);
        	}
        	else {
        		temp.push(xArray[i]);
        	}
        }
    	
        $(groups).each(function(){//写到这儿了，这边的循环嵌套的，里面还有一个！！！
        	var groupName=$(this).attr("group");
        	var groupMates=[];
        	 $(groups).each(function(){
        		 if($(this).attr("group")==groupName){
        			 groupMates.push(this);
        		 }
        	 });
        	alert(groupMates.length);
        	$(this).focus(function()
    				{
        		//alert(1);
                        $(this).removeClass('tooltipinputerr');
                    }).blur(function(){
                    	if($(this).val()!=null||$(this).val()!=""){
                    		
                    	}
                    	//alert(2);
                    });
        });*/
        
        this.each(function(){//初始化提示块的显示状态，以便之后在输入正常是能够隐藏
        	if($(this).val()==null||$(this).val()==""){//如果之前载入过信息则不作提示
        		$(this).attr("ifDisplay","true");
        	}else {
        		$(this).attr("ifDisplay","false");
        	}
        });
        
        this.each(function(){
        	var currInput=$(this);
            if($(this).attr('tip') != '')
            {	
                $(this).mouseover(function(){
                	if(currInput.attr("ifDisplay")=="true"){
                		$('#tipTable').css({left:$.getLeft(this)+'px',top:$.getTop(this)+'px'});
                        $('.contenImage').html($(this).attr('tip'));
                        $('#tipTable').fadeIn("fast");
                	}
                }/*,
                function(){//这个是低版本的jquery的语句，已被我屏蔽
                    $('#tipTable').hide();
                }*/);
            }
            if($(this).attr('check') != '')//这里貌似应该改成!=undefined
            {
				
                $(this).focus(function()
				{
                    $(this).removeClass('tooltipinputerr');
                }).blur(function(){
                    if($(this).attr('toupper') == 'true')
                    {
                        this.value = this.value.toUpperCase();
                    }
					if($(this).attr('check') != '')
					{
						
						if($(this).attr('check')=="1")
						{
							
							
							if($(this).attr('value')==""||$(this).attr('value')==null)
							{
								currInput.attr("ifDisplay","false");
								$(this).removeClass('tooltipinputerr');//有时候没必要显示那个绿色的
								//$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
							}else
							{//核心比较代码
								
								var thisReg = new RegExp($(this).attr('reg'));
								if(thisReg.test(this.value))
								{
									currInput.attr("ifDisplay","false");
									$(this).removeClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
								}
								else
								{
									currInput.attr("ifDisplay","true");
									$(this).addClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputok').addClass('tooltipinputerr');
								}
								
							}
						}
						if($(this).attr('check')=="2")
						{
							var thisReg = new RegExp($(this).attr('reg'));
								if(thisReg.test(this.value))
								{
									
									currInput.attr("ifDisplay","false");
									$(this).removeClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
								}
								else
								{
									currInput.attr("ifDisplay","true");
									$(this).addClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputok').addClass('tooltipinputerr');
								}
						}			
					}
                    
                });
            }
            $(this).focus(function()
    				{
                        $(this).removeClass('tooltipinputerr');
                    }).blur(function(){
                    	if(currInput.attr('customFunc') !=undefined){//调用一个自定义方法
                        	var func=currInput.attr('customFunc');
                        	var param=currInput.val();
                        	if(param!=''){
                        		var funcCall=func+"('"+param+"')";
                            	if(eval(funcCall)){
                            		currInput.attr("ifDisplay","false");
                					currInput.removeClass('tooltipinputerr');
                					//currInput.removeClass('tooltipinputerr').addClass('tooltipinputok');
                            	}
                            	else {
                            		currInput.attr("ifDisplay","true");
                					currInput.addClass('tooltipinputerr');
                					//currInput.removeClass('tooltipinputok').addClass('tooltipinputerr');
                            	}
                        }
                   }
               });
        });
		
return {
 validateForm:function(){
                    var isSubmit = true;
                getthis.each(function(){
                	var currInput=$(this);
					if($(this).attr('check')=="1")
						{
							if($(this).attr('value')==null||$(this).attr('value')=="")
							{
								currInput.attr("ifDisplay","false");
								$(this).removeClass('tooltipinputerr');
								//$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
							}else
							{
								
								var thisReg = new RegExp($(this).attr('reg'));
								if(thisReg.test(this.value))
								{
									currInput.attr("ifDisplay","false");
									$(this).removeClass('tooltipinputerr');
								//	$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
								}
								else
								{
									currInput.attr("ifDisplay","true");
									$(this).addClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputok').addClass('tooltipinputerr');
									isSubmit = false;
								}
							}
						}
                    if($(this).attr('check')=="2")
						{
							var thisReg = new RegExp($(this).attr('reg'));
								if(thisReg.test(this.value))
								{
									currInput.attr("ifDisplay","false");
									$(this).removeClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputerr').addClass('tooltipinputok');
								}
								else
								{
									currInput.attr("ifDisplay","true");
									$(this).addClass('tooltipinputerr');
									//$(this).removeClass('tooltipinputok').addClass('tooltipinputerr');
									isSubmit = false;
								}
						}
                    if(currInput.attr('customFunc') !=undefined){//调用一个自定义方法
                    	var func=currInput.attr('customFunc');
                    	var param=currInput.val();
                    	if(param!=''){
                    		var funcCall=func+"('"+param+"')";
                        	if(eval(funcCall)){
                        		currInput.attr("ifDisplay","false");
            					currInput.removeClass('tooltipinputerr');
            					//currInput.removeClass('tooltipinputerr').addClass('tooltipinputok');
                        	}
                        	else {
                        		currInput.attr("ifDisplay","true");
            					currInput.addClass('tooltipinputerr');
            					//currInput.removeClass('tooltipinputok').addClass('tooltipinputerr');
                        	 }
                       }
                   }
                });
                return isSubmit;
 }

};
          
};

    $.extend({
        getWidth : function(object) {
            return object.offsetWidth;
        },

        getLeft : function(object) {
            var go = object;
            var oParent,oLeft = go.offsetLeft;
            while(go.offsetParent!=null) {
                oParent = go.offsetParent;
                oLeft += oParent.offsetLeft;
                go = oParent;
            }
            return oLeft;
        },

        getTop : function(object) {
            var go = object;
            var oParent,oTop = go.offsetTop;
            while(go.offsetParent!=null) {
                oParent = go.offsetParent;
                oTop += oParent.offsetTop;
                go = oParent;
            }
            return oTop + $(object).height()+ 5;
        }
    });
    $.fn.tooltip.defaults = { onsubmit: true };
})(jQuery);

//***************************************************************************************************************************************************
//利用JQuery功能对标签属性设置表达式
//传入的标签ID组必须为"name1:name2:name3"中间用':'分隔.


//对所有需要整数验证的标签进行设置正则表达式
function setIntegeCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^[1-9]\\d*$");
		}
	}
}

//对所有需要金额验证的标签进行设置正则表达式
function setMoneyCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$");
		}
	}
}

//对所有需要正浮点验证的标签进行设置正则表达式
function setFloatCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^[0-9]+\\.[0-9]+$");
		}
	}
}

//对所有需要电子邮件验证的标签进行设置正则表达式
function setMailCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$");
		}
	}
}

//对所有需要邮编验证的标签进行设置正则表达式
function setZipcodeCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^\\d{6}$");
		}
	}
}

//对所有需要手机验证的标签进行设置正则表达式
function setMobileCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^(13|15)[0-9]{9}$");
		}
	}
}

//对所有需要身份证验证的标签进行设置正则表达式
function setIDCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^[1-9]([0-9]{14}|[0-9]{17})$");
		}
	}
}

//对所有需要登录帐号验证的标签进行设置正则表达式
function setUserIDCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^\\w+$");
		}
	}
}

//对所有需要非空验证的标签进行设置正则表达式
function setEmptyCheck(validatorString)
{
	
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg",'.*\\S.*');
		}
	}
}

//对所有需要中文验证的标签进行设置正则表达式
function setChineseCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$");
		}
	}
}

//对所有需要URL验证的标签进行设置正则表达式
function setURLCheck(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$");
		}
	}
}
//匹配国内电话号码(0511-4405222 或 021-87888822) 
function setTell(validatorString)
{
	var validatorStrings="";
	if(validatorString!="")
	{
		validatorStrings=validatorString.split(":");
		for(i=0;i<validatorStrings.length;i++)
		{
			$("#"+validatorStrings[i]).attr("reg","\\d{3}-\\d{8}|\\d{4}-\\d{7}");
		}
	}
}  
//***************************************************************************************************************************************************