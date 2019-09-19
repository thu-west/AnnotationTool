$(".txt").find("span").click(function(){
	var msg=$(this).html();
	alert(msg);
});

function testAjax(type) { //添加标注后调用

	var users = {'content': $(".message").html(), 'type': type};
	
	$.ajax({
	
		type:'POST',
		
		data:JSON.stringify(users),
		
		contentType: "application/json; charset=utf-8", 
		dataType:'json',
		
		url :'/annotationTool/jsonmark',
			
		success :function(data) {
			
			alert("OK");
		
		}		
	});
	
}

//添加自定义标签
$(document).ready(function(){
	
	var id;
	var delFlag;
	var color, rel;
	var color1, color2;
	var anno1, anno2;
	var tr = document.createElement("tr");
	var th = document.createElement("th");
	var th1 = document.createElement("th");
	var th2 = document.createElement("th");
	var thr = document.createElement("th");
	var count =  document.getElementsByTagName("tr").length - 1;
	
	var flag;
	
	var flagBtn = 0;
	
	//var type = 0;//当前标注按钮个数 document.getElementsByClassName("button").length;
	var label;// = 1;//当前总标注个数  
	//var label = document.getElementsByTagName("span").length;
	//具体计算for？
	var labelDel = [
		[{
			text: "删除实体标签",
			func: function() {
				var val = $(this).attr("value");
				var Btns = {'value':val};
				
				$.ajax({
				
					type:'POST',
					
					data:JSON.stringify(Btns),
					
					contentType: "application/json; charset=utf-8", 
					dataType:'json',
					
					url :'/annotationTool/jsonDelEntityBtn',
						
					success :function(data) {
						
						alert("OK");
					
					}		
				});
				
				$(this).remove();
			}
		}],
	];
	var labelData = [
		[{
			text: "添加关系",
			func: function() {
				if(anno1 == undefined) {
					count =  document.getElementsByTagName("tr").length - 1;
					color = $(this).css("background-color");
					color1 = color;
					
					tr.id = count + 1;
					th.innerHTML = count + 1;
					
					count++;
					$("tbody").append(tr);
					$("[id='"+count+"']").append(th);
					anno1 = $(this).html().split("/")[0]
					th1.innerHTML = anno1;
					th1.style.background = color;
					$("[id='"+count+"']").append(th1);
					
				$("tr").smartMenu(relData, {
					name: "rel"	
				});
				}
				else if((anno1 != undefined)&&(anno2 == undefined)) {
					color = $(this).css("background-color");
					color2 = color;
					anno2 = $(this).html().split("/")[0]
					th2.innerHTML = anno2;
					th2.style.background = color;
					$("[id='"+count+"']").append(th2);
				}
			}
		},
		{
			text: "搜索",
			func: function() {
			    var str = $(this).html();
				var inhtml = str.split("/")[0];
				$(".searchCont").val(inhtml);	
			}
		},
		{
			text: "删除标签",
			func: function() {
				var str = $(this).html();
				var lab = $(this).attr("lab");
				
				var inhtml = str.split("/")[0];
				//alert(lab);
				str.substring(0, str.indexOf("#"));
				$(this).replaceWith(inhtml);
				
				$("span").each(function(){  
		            if ($(this).attr("lab") > lab) {
		            	$(this).attr("lab", $(this).attr("lab")-1);
		            }
		    	});
				
				//删除标签的内容与数据库匹配
				var labels = {'content':inhtml};
				
				$.ajax({
				
					type:'POST',
					
					data:JSON.stringify(labels),
					
					contentType: "application/json; charset=utf-8", 
					dataType:'json',
					
					url :'/annotationTool/jsonDelLabel',
						
					success :function(data) {
						
						alert("OK");
					
					}		
				});
				
				$(this).remove();
			}
		}],
	];
	var relData = [
		[{
			text: "删除关系",
			func: function() {
				if(($(this).attr("class")!="list")){
					id = $(this).attr("id");
					
					var a = $(this).find("th:first-child").html();
					var a1 = $(this).children().eq(1).html();
					var a2 = $(this).children().eq(2).html();
					var a3 = $(this).children().eq(3).html();
					
					var delRelations = {'model1': a1, 'model2': a2, 'relation': a3};
					
					$.ajax({
					
						type:'POST',
						
						data:JSON.stringify(delRelations),
						
						contentType: "application/json; charset=utf-8", 
						dataType:'json',
						
						url :'/annotationTool/jsonDelRelation',
							
						success :function(data) {
							
							alert("OK");
						
						}		
					});
//							alert($(this).find("th:third-child").html());
					$("tr").each(function(){
			    		if ($(this).attr("id") > id) {
			    			$(this).attr("id", $(this).attr("id")-1);
			    			var num = $(this).find("th:first-child");
			    			$(this).find("th:first-child").html($(this).attr("id"));
			    		}
			    	});
					
					color1 = undefined;
					color2 = undefined;
					anno1 = undefined;
					anno2 = undefined;
					tr = document.createElement("tr");
					th = document.createElement("th");
					th1 = document.createElement("th");
					th2 = document.createElement("th");
					thr = document.createElement("th");
					
					$(this).remove();
				}
			}
		}],
	];

	var relDel = [
		[{
			text: "删除关系标签",
			func: function() {
				var relButtons = {'value': $(this).attr("value")};
			
				$.ajax({
				
					type:'POST',
					
					data:JSON.stringify(relButtons),
					
					contentType: "application/json; charset=utf-8", 
					dataType:'json',
					
					url :'/annotationTool/jsonDelRelationBtn',
						
					success :function(data) {
						
						alert("OK");
					
					}		
				});
				$(this).remove();	
			}
		}],
	];
	$(".button").smartMenu(labelDel, {
		name: "labelbtn"	
	});
	$(".relbutton").smartMenu(relDel, {
		name: "relbtn"	
	});
	$("span").smartMenu(labelData, {
		name: "label"	
	});
	$("tr").smartMenu(relData, {
		name: "rel"	
	});
	$(".confirmBtn").click(function(){

		
		var btn = document.createElement("input");
		//alert($(".selectText").val());
		var color = $(".selectColor").val();
		var str = $(".selectText").val();
		var id = $(".selectId").val();
		
		//alert(color);
		if(str.length == 0) {
			alert("内容为空!");
			 $(".selectText").focus();
			return false;
		}
		//alert("/");
		if((id.charAt(0))!="/") {
			alert("符号格式不对!");
			$(".selectId").focus();
			return false;
		}

		btn.id = id;
	    btn.className = "button btn btn-primary";
	    btn.type = "button";
	    btn.style.background = color;
	    btn.value = str;

		btn.onclick=function(){
	    				
			label =  document.getElementsByTagName("span").length;
			label++;
			//alert(label);
			
			if(document.selection) {
				var txt=document.selection.createRange();
		        txt.execCommand("ForeColor", false, background);
		          
			}
			else {
				
		    	var txt = document.getSelection().getRangeAt(0);
		    	//alert(txt);
		    	if(txt == "") {
		    		alert("未选择内容！");
		    		return false;
		    	}
		    	var color = $(this).css("background-color");
		    	var clas = $(this).attr("id");
				//alert(clas);
				
		        var span = document.createElement("span");
		        
		        span.className = clas;
		        span.style.background = color;
		        //span.type = 1;
		        
		        span.setAttribute("lab", label);
	
		        txt.surroundContents(span);
		        var txt = document.getSelection().getRangeAt(0);
		        
		        //获取所有span lab值，如果lab值等于label，则添加
		        //var spa = document.getElementsByTagName("span");
		        //alert(spa.length);
	
		        $("[lab='"+label+"']").append(clas);//动态选择
		        
				$("span").smartMenu(labelData, {
					name: "label"	
				});
		        testAjax();
		        label++;      
			}
	    
	    	
		};
		
	    var buttons = {'id': $(".selectId").val(), 'color': $(".selectColor").val(), 'value': $(".selectText").val()};
		
		$.ajax({
		
			type:'POST',
			
			data:JSON.stringify(buttons),
			
			contentType: "application/json; charset=utf-8", 
			dataType:'json',
			
			url :'/annotationTool/addLabel',
				
			success :function(data) {
				
				alert("OK");
			
			}		
		});
		$(".addlab").before(btn);		
		$(".button").smartMenu(labelDel, {
			name: "labelbtn"	
		});

	});
	
	$(".button").click(function(){
		
		label =  document.getElementsByTagName("span").length - 3;
		//alert(label);
		label++;
		//alert(label);
		
		if(document.selection) {
			var txt=document.selection.createRange();
	        txt.execCommand("ForeColor", false, background);
	          
		}
		else {
			
	    	var txt = document.getSelection().getRangeAt(0);
	    	//alert(txt);
	    	if(txt == "") {
	    		alert("未选择内容！");
	    		return false;
	    	}
	    	var color = $(this).css("background-color");
	    	var clas = $(this).attr("id");
			//alert(clas);
			
	        var span = document.createElement("span");
	        //span.on('click', function() {
	        span.className = clas;
	        span.style.background = color;
	        //span.type = 1;
	        
	        span.setAttribute("lab", label);

	        txt.surroundContents(span);
	        var txt = document.getSelection().getRangeAt(0);
	        
	        //获取所有span lab值，如果lab值等于label，则添加

	        //alert($("[lab='"+label+"']").attr("class"));
	        $("[lab='"+label+"']").append(clas);//动态选择
			
			$("span").smartMenu(labelData, {
				name: "label"	
			});
	        testAjax();
	        label++;
	        
	        return false;
		}
	});
	
	$(".base").click(function(){
		$(".base").each(function(){  
            //alert($(this).css("background-color"));
            $(this).parent().attr("class", "");
			//$(this).css("background-color", "rgb(240, 240, 240)");
     	});
     	
     	$(this).parent().attr("class", "active");
		//$(this).css("background-color", "#ABABAB");
		$(".searchCont").attr("placeholder", $(this).html());
	});

	$(".searchConfirm").click(function(){	
		var str = $(".searchCont").val();
		var base;
		$(".base").each(function(){  
			if($(this).parent().attr("class")=="active") {
				base = $(this).html();
			}
     	});

		if(base == "百度") {
			var url = "http://baike.baidu.com/item/" + str;
			window.open(url);
		}
	});
	
	$(".relbutton").click(function(){
		
		if((anno1 != undefined)&&(anno2 != undefined)) {
			rel = $(this).attr("value");
			thr.innerHTML = rel;
			$("[id='"+count+"']").append(thr);
//			alert(anno2);
//			alert($(this).attr("value"));
			var relations = {'model1': anno1, 'model2': anno2, 'color1': color1, 'color2': color2, relation: $(this).attr("value")};
			
			$.ajax({
			
				type:'POST',
				
				data:JSON.stringify(relations),
				
				contentType: "application/json; charset=utf-8", 
				dataType:'json',
				
				url :'/annotationTool/jsonRelation',
					
				success :function(data) {
					
					alert("OK");
				
				}		
			});
			color1 = undefined;
			color2 = undefined;
			anno1 = undefined;
			anno2 = undefined;
			tr = document.createElement("tr");
			th = document.createElement("th");
			th1 = document.createElement("th");
			th2 = document.createElement("th");
			thr = document.createElement("th");
			
		}
		else {
			alert("实体未选择！");
		}
	});
	
	$(".confirmRel").click(function(){
		
		var btn = document.createElement("input");
		var str = $(".selectTextrel").val();
		
		if(str.length == 0) {
			alert("内容为空!");
			 $(".selectTextrel").focus();
			return false;
		}

	    btn.className = "relbutton btn btn-primary";
	    btn.type = "button";
	    btn.value = str;

		btn.onclick=function(){
			
			if((anno1 != undefined)&&(anno2 != undefined)) {
				rel = $(this).attr("value");
				thr.innerHTML = rel;
				$("[id='"+count+"']").append(thr);
				
				var relations = {'model1': anno1, 'model2': anno2, 'color1': color1, 'color2': color2, 'relation': $(this).attr("value")};
				
				$.ajax({
				
					type:'POST',
					
					data:JSON.stringify(relations),
					
					contentType: "application/json; charset=utf-8", 
					dataType:'json',
					
					url :'/annotationTool/jsonRelation',
						
					success :function(data) {
						
						alert("OK");
					
					}		
				});
				
				anno1 = undefined;
				anno2 = undefined;
				tr = document.createElement("tr");
				th = document.createElement("th");
				th1 = document.createElement("th");
				th2 = document.createElement("th");
				thr = document.createElement("th");
		
			}
			else {
				alert("实体未选择！");
			}
		};
		$(".addrel").before(btn);
		$(".relbutton").smartMenu(relDel, {
			name: "relbtn"	
		});
		
		var relButtons = {'value': $(".selectTextrel").val()};
	
		$.ajax({
		
			type:'POST',
			
			data:JSON.stringify(relButtons),
			
			contentType: "application/json; charset=utf-8", 
			dataType:'json',
			
			url :'/annotationTool/jsonRelationBtn',
				
			success :function(data) {
				
				alert("OK");
			
			}		
		});
	});
	
});
