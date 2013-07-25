// JavaScript Document
		$('show_homeroom_child').style.display='';
		$("nav_homeroom_start").className="selected";
		$$('.addfile').each(function(item){
			item.onclick= function(){
				var newNode = document.createElement("span");;
				newNode.innerHTML = '<input type=\'file\' /> <a href=\'#\' onclick = \'confirm(\&apos;削除してもよろしいですか？\&apos;);\'>削除</a><br />';
				this.parentNode.insertBefore(newNode, this);		
			}				
		})
