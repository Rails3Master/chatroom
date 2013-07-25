// JavaScript Document
window.onload = function(){
		$("before_btn").onclick=function(){
				$("status01").selected = true
				$("status02").selected = false
				$('before_tab').style.display='block';
				$('after_tab').style.display='none';
				
			}
		$("after_btn").onclick=function(){
				$("status02").selected = true
				$("status01").selected = false
				$('before_tab').style.display='none';
				$('after_tab').style.display='block';
				
			}
		$("adjust_amount").onclick=function(){
				$('show_amount').style.display='none';
				$('edit_amount').style.display='block';
				$('adjust_amount').style.display='none';
				$('deal_amount').style.display='block';
			}
		$("deal_amount").onclick=function(){
				$('show_amount').style.display='block';
				$('edit_amount').style.display='none';
				$('deal_amount').style.display='none';
				$('adjust_amount').style.display='block';
			}
		
		$("status").onchange = function(){
		if($("status01").selected){
			$('before_tab').style.display='block';
			$('after_tab').style.display='none';
			}
		if($("status02").selected){
			$('before_tab').style.display='none';
			$('after_tab').style.display='block';
			}
		}
	}