// JavaScript Document
window.onload = function(){
	$("subjeck1").onclick = function(){
		$("content1").toggle();
		if($("content1").getStyle('display') == "none"){
			$("subjeck1_is_open").replace('<span id="subjeck1_is_open" style="margin-right: 50px;">+</span>');
		}else
		{
			$("subjeck1_is_open").replace('<span id="subjeck1_is_open" style="margin-right: 50px;">-</span>');
		}	
	};
	$("subjeck2").onclick = function(){
		$("content2").toggle();
		if($("content2").getStyle('display') == "none"){
			$("subjeck2_is_open").replace('<span id="subjeck2_is_open" style="margin-right: 50px;">+</span>');
		}else
		{
			$("subjeck2_is_open").replace('<span id="subjeck2_is_open" style="margin-right: 50px;">-</span>');
		}	
	};
	$("subjeck3").onclick = function(){
		$("content3").toggle();
		if($("content3").getStyle('display') == "none"){
			$("subjeck3_is_open").replace('<span id="subjeck3_is_open" style="margin-right: 50px;">+</span>');
		}else
		{
			$("subjeck3_is_open").replace('<span id="subjeck3_is_open" style="margin-right: 50px;">-</span>');
		}	
	};
}