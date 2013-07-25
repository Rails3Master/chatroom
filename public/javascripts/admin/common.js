// JavaScript Document

window.onload = function(){
    switchImg();
		//editbox();
}

//switchImg
function switchImg(){
    try {
        var obj = document.getElementsByClassName('hover');
        for (i = 0; i < obj.length; i++) {
            obj[i].onmouseover = function(){
                this.src = this.src.replace(/(.+?)(\.gif|\.png|\.jpg)/g, "$1_on$2")
            }
            obj[i].onmouseout = function(){
                this.src = this.src.replace(/_on/g, "");
            }
        }
    } 
    catch (e) {
    }
}

//editbox style
/*function editbox(){
	var tboxs = document.getElementsByTagName('input');
	var tarea = document.getElementsByTagName('textarea');
	for(i=0;i<tboxs.length;i++){
		if(tboxs[i].type == 'text'){
			var cn01 = tboxs[i].className;
			tboxs[i].className = cn01 + ' editbox';
		}
	}
	for(i=0;i<tarea.length;i++){
		var ta01 = tarea[i].className;
		tarea[i].className = ta01 + ' editbox';
	}
}*/


//shadowbox open
function openWithSBox(url, h, w){
	Shadowbox.open({
		content: url,
		player: "iframe",
		width: w+'px',
		height: h+'px',
		resizable: false
	});
}