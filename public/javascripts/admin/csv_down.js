// JavaScript Document
window.onload=function(){
		$("conf").onclick=function(){
				if (confirm("確認してもよろしいですか？")){
					$("send01").style.display='block';
					$("conf").style.display='none';
					var str = $("status01").innerHTML;
					str = str.replace("未確認","確認済み");
					$("status01").innerHTML=str;
				}
			}
			$("send01").onclick=function(){
				if (confirm("送信してもよろしいですか？")){
					$("send01").style.display='none';
					var str = $("status01").innerHTML;
					str = str.replace("確認済み","送信済み");
					$("status01").innerHTML=str;
				}
			}
			$("send02").onclick=function(){
				if (confirm("送信してもよろしいですか？")){
					$("send02").style.display='none';
					var str = $("status02").innerHTML;
					str = str.replace("確認済み","送信済み");
					$("status02").innerHTML=str;
				}
			}
	}