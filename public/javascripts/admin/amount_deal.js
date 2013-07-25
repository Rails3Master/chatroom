window.onload = function(){
		var i = 1
		for(i;i<8;i++){
			$("remove0" +i).setAttribute( 'onclick',
					'if (confirm("月額解約してもよろしいですか？")){$("add0" +'+ i +').style.display="inline-block";$("remove0" +'+ i +').style.display="none";var str = $("status0" +　'+ i +').innerHTML;str = str.replace("いいえ","はい");$("status0"+'+ i +').innerHTML=str;}')
			}
			var j = 1
		for(j;j<8;j++){
			$("add0" +j).setAttribute( 'onclick',
					'if (confirm("削除してもよろしいですか？")){$("add0" +'+ j +').style.display="none";$("remove0" +'+ j +').style.display="inline-block";var str = $("status0" +　'+ j +').innerHTML;str = str.replace("はい","いいえ");$("status0"+'+ j +').innerHTML=str;}')
			}
	
}
		
			