window.onload = function(){
	$("edit_exam").onclick = function(){
		$("exam_detail").replace('<div id="exam_detail"><table class="tform mb10" width="100%"><tr><th width="15%"> コース </th><td width="15%"> ダミー </td><th width="15%"> テスト名 </th><td colspan="3" width="60%"><input value="サンプルテスト【色彩学】" size="50"/></td></tr><tr><th> 公開 </th><td> <input type="checkbox" checked="checked" /> </td><th width="15%"> 表示順 </th><td width="20%"><input size="3" value="3" /></td><th width="15%"> 合計点数 </th><td width="20%"> 100 点 </td></tr></table><div class="btnbar"><input type="button" value="登録" id="edit_confirm" onclick="location.href=\'/admin/views/exam/exam_detail.html\'" /> <input type="button" value="戻る" onclick="location.href=\'/admin/views/exam/exam_detail.html\'"/></div></div>');

	}
}