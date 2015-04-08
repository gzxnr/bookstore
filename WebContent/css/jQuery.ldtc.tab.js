/**
 * Title:生成TAB的JQUERY插件<br>
 * Copyright: Copyright (c) 2012<br>
 * Company:呼和浩特市凌动信息科技有限公司<br>
 * 
 * @author 索龙嘎<br>
 * @version 1.0 2012-4-16<br>
 *          Description: DIV中将生成形如下述的HTML代码：
 */
/*
 * <table width="100%" height="479" border="0" cellpadding="0" cellspacing="0">
 * <tr> <td height="32" class="contentmenu"> <table width="1003" border="0"
 * cellspacing="0" cellpadding="0"> <tr> <td> <ul> <li class="home">主 页</li>
 * <li>会员管理啊啊</li> <li><span class="text">会员管理啊啊啊</span> <span
 * class="close"></span></li> <li class="on">会员管理啊啊</li> <li>会员管理啊啊</li>
 * <li>会员管理啊啊</li> </ul> </td> </tr> </table> </td> </tr> <tr>
 * <td bgcolor="#FFFFFF" class="mainboxc"> <iframe width="100%" height="100%"
 * scrolling="no" src="" frameborder="0" >显示的</iframe> <iframe width="100%"
 * height="100%" scrolling="no" src="" frameborder="0" >不显示的</iframe> <iframe
 * width="100%" height="100%" scrolling="no" src="" frameborder="0" >不显示的</iframe>
 * </td> </tr> </table>
 */

(function($) {
	$.fn.ldtcTab = function(options) {
		var t_obj = $(this);
		var t_opts = $.extend($.fn.ldtcTab.defaults, options);

		// 创建节点
		var t_mainTable = $("<table></table>"); // 主框架TABLE
		var t_barTr = $("<tr></tr>"); // tab条的tr
		var t_barTd = $("<td></td>"); // tab条的td
		var t_barTable = $("<table></table>"); // tab条中的内部table
		var t_barTableTr = $("<tr></tr>"); // 内部table中的tr
		var t_barTableTrTd = $("<td></td>"); // 内部table中的tr中的td
		var t_barUl = $("<ul></ul>");

		var t_mainTr = $("<tr></tr>"); // 主页面的tr
		var t_mainTrTd = $("<td></td>");

		// 对创建的节点进行连接
		t_obj.append(t_mainTable);
		t_mainTable.append(t_barTr);
		t_barTr.append(t_barTd);
		t_barTd.append(t_barTable);
		t_barTable.append(t_barTableTr);
		t_barTableTr.append(t_barTableTrTd);
		t_barTableTrTd.append(t_barUl);

		t_mainTable.append(t_mainTr);
		t_mainTr.append(t_mainTrTd);

		// 对节点中的属性进行设置
		t_mainTable.attr("width", t_opts.width).attr("height", t_opts.height)
				.attr("border", "0").attr("cellpadding", "0").attr(
						"cellspacing", "0");
		t_barTd.attr("height", t_opts.tabBarHeight).attr("class",
				t_opts.tabBarCls);
		t_barTable.attr("width", t_opts.tabBarWidth).attr("border", "0").attr(
				"cellpadding", "0").attr("cellspacing", "0");
		t_mainTrTd.attr( {
			'bgcolor' : t_opts.mainBgcolor,
			'class' : t_opts.mainCls
		});

		// 初始化首页
		var homeFrame = $("<iframe scrolling='no'  frameborder='0' ></iframe>");
		var homeLi = $("<li ></li>");
		homeLi.attr( {
			'id' : $.fn.ldtcTab.defaults.tabHomeId,
			'class' : t_opts.tabHomeCls,
			'url' : t_opts.homeUrl
		});
		homeFrame.attr("width", $.fn.ldtcTab.defaults.mainFrameWidth);
		homeFrame.attr("height", $.fn.ldtcTab.defaults.mainFrameHeight);
		homeFrame.attr("id", $.fn.ldtcTab.defaults.tabHomeId);

		homeLi.html(t_opts.homeText);
		t_barUl.append(homeLi);
		t_mainTrTd.append(homeFrame);
		g_addListener(t_barUl, $.fn.ldtcTab.defaults.tabHomeId, t_mainTrTd); // 添加监听
		g_selectTab(t_barUl, $.fn.ldtcTab.defaults.tabHomeId, t_mainTrTd); // 选中

		return {
			addTabItem : function(id, text, url) {// 添加一个tab标签
				var frame = $("<iframe  scrolling='yes'  frameborder='0' ></iframe>");
				var li = $("<li ></li>");
				var liSpanText = $("<span></span>");
				var liSpanClose = $("<span></span>");
				liSpanText.attr("class", $.fn.ldtcTab.defaults.tabTextCls);
				liSpanClose.attr("class", $.fn.ldtcTab.defaults.tabCloseCls);
				li.attr( {
					'id' : id,
					'url' : url
				});
				frame.attr("id", id);
				frame.attr("width", $.fn.ldtcTab.defaults.mainFrameWidth);
				frame.attr("height", $.fn.ldtcTab.defaults.mainFrameHeight);
				liSpanText.html(text);
				t_barUl.append(li);
				li.append(liSpanText);
				li.append(liSpanClose);
				t_mainTrTd.append(frame);
				g_addListener(t_barUl, id, t_mainTrTd); // 启用选择监听
				g_addCloseListener(t_barUl, id, t_mainTrTd);// 启用关闭监听
				g_selectTab(t_barUl, id, t_mainTrTd);
			},
			closeTabItem : function(id) { // 关闭指定的tab标签
				g_deleteTabById(t_barUl, id, t_mainTrTd);
			},
			isTabItemExist : function(id) { // 判断标签是否已经存在
				var tab = g_getTabById(t_barUl, id);
				if (tab == null) {
					return false;
				} else
					return true;
			},
			activeTabItem : function(id) { // 激活指定ID的tab
				g_selectTab(t_barUl, id, t_mainTrTd);
			},
			getActiveTabs:function(){ //得到目前打开的tabs
				return t_mainTrTd.children();
			},
			getCurrentTabFrame : function() {
				g_getCurrentTabFrame(t_barUl, t_mainTrTd);
			},
			test : function() {

			}
		};
	};

	$.fn.ldtcTab.defaults = {
		width : '100%',
		height : 479,
		tabBarWidth : 1003,
		tabBarHeight : 32,
		tabBarCls : 'contentmenu',
		tabHomeCls : 'home',
		tabHomeOnCls : 'homeon',
		tabHomeId : 'home',
		tabOnCls : 'on',
		tabTextCls : 'text',
		tabCloseCls : 'close',
		mainBgcolor : '#FFFFFF',
		mainCls : 'mainboxc',
		mainFrameWidth : '100%',
		mainFrameHeight : 447,
		homeUrl : '',
		homeText : '首页'
	};

	function g_addListener(ul, id, mainTd) { // 为ul下的每一个新增的tab添加激活tab的监听
		ul.children().each(function() {
			if ($(this).attr('id') == id) { // 找到当前的tab，为之添加激活监听
					if ($(this).attr('id') == $.fn.ldtcTab.defaults.tabHomeId) {// 是主页面标签
						$(this).click(function() {
							g_selectTab(ul, id, mainTd);
						});
					} else {// 是普通页面标签，因此有span节点
						var li = $(this);
						$(li.children()[0]).click(function() {// 注意，使用数组取出的值需要再用$封装一下
									g_selectTab(ul, id, mainTd);
								});
					}

				}
			});
	}

	function g_addCloseListener(ul, id, mainTd) {// 为每一个tab的关闭按钮添加关闭tab的监听
		ul.children().each(function() {
			if ($(this).attr('id') == id) { // 找到当前的tab，为之添加关闭监听
					var li = $(this);
					var frame = g_getFrameById(mainTd, id);
					$(li.children()[1]).click(function() {
						if (g_isActive(ul, id)) {
							g_selectTab(ul, li.prev("li").attr('id'), mainTd);
						}
						li.remove();
						frame.remove();
					});
				}
			});
	}

	function g_deleteTabById(ul, id, mainTd) {
		ul.children().each(function() {
			if ($(this).attr('id') == id) {
				var li = $(this);
				var frame = g_getFrameById(mainTd, id);
				g_selectTab(ul, li.prev("li").attr('id'), mainTd);
				li.remove();
				frame.remove();
			}
		});
	}

	function g_selectTab(ul, id, mainTd) { // 将指定ID的tab项置为选中状态，并且激活相应的frame
		var url = g_getTabById(ul, id).attr("url");
		ul.children().each(function() {
			if ($(this).attr("id") == id) {
				if ($(this).attr("id") == $.fn.ldtcTab.defaults.tabHomeId) {
					$(this).attr("class", $.fn.ldtcTab.defaults.tabHomeOnCls);
				} else {
					$(this).attr("class", $.fn.ldtcTab.defaults.tabOnCls);
				}
			} else {
				if ($(this).attr("id") == $.fn.ldtcTab.defaults.tabHomeId) {
					$(this).attr('class', $.fn.ldtcTab.defaults.tabHomeCls);
				} else {
					$(this).attr('class', "");
				}
			}
		});
		var frame = g_activeFrame(mainTd, id, url);
	}

	function g_isActive(ul, id) { // 判断此TAB项是否属于激活状态
		var li = g_getTabById(ul, id);
		if (li.attr('class') == $.fn.ldtcTab.defaults.tabOnCls) {
			return true;
		} else
			return false;
	}

	function g_activeFrame(mainTd, id, url) { // 激活一个frame
		mainTd.children().each(function() {
			if ($(this).attr("id") == id) {
				$(this).css("display", "");
				if ($(this).attr("src") != url) {
					$(this).attr("src", encodeURI(url)); // 由于iframe中的src不能传递汉字，必须encodeURI转换编码，再于页面中转回
			}
		} else {
			$(this).css("display", "none");
		}
	}	);
	}

	function g_getTabById(ul, id) { // 返回ul中指定ID的li节点对象
		var c = ul.children();
		var v = null;
		c.each(function(index) {
			if (id == $(this).attr("id")) {
				v = $(this);
			}
		});
		return v;
	}

	function g_getFrameById(mainTd, id) { // 通过ID来返回一个frame对象
		var v = null;
		mainTd.children().each(function() {
			if ($(this).attr("id") == id) {
				v = $(this);
			}
		});
		return v;
	}

	function g_getCurrentTabFrame(ul, mainTd) {//得到当前的活动FRAME对象
		var frame=null;
		ul.children().each(function() {
			if ($(this).attr("class") == $.fn.ldtcTab.defaults.tabOnCls) { // 找到当前的活动tab
					var id = $(this).attr('id');
					frame= g_getFrameById(mainTd, id);
				}
			});
		return frame;
	}

})(jQuery);
