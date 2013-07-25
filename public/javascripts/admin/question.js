// JavaScript Document
//add by zyc 20110623
//function add_answer(table_id){
//    console.log(2);
//    a = $$('#' + table_id + ' tr')[1].cloneNode(true);
//    a.childElements()[1].childElements()[0].checked = false
//    a.childElements()[1].childElements()[1].value = false
//    a.childElements()[2].childElements()[0].value = ''
//    if(a.childElements()[3].childElements()[0].type == 'hidden')
//    {
//        a.childElements()[3].childElements()[0].value ='';
//    }
//    $$('#' + table_id + ' tbody')[0].insert(a);
//    answer_sort(table_id);
//}

//edit by zq 20120215
function add_answer(table_id){
   var choices_tr_no = $$('#' + table_id +' tr td.sort').length + 1;
   var old_tr = $$('#' + table_id + ' tr')[1];
   var new_tr = old_tr.cloneNode(true);

   //正解
   var conrrect_td = new_tr.childElements()[1];
   conrrect_td.childElements()[0].checked = false
   conrrect_td.childElements()[1].value = '';
   //選択肢
   var item_td = new_tr.childElements()[2];
   item_td.childElements()[0].value = ''

   //画像ファイル
   var image_file_td = new_tr.childElements()[3];
   var image_file_td_preview = image_file_td.childElements()[0];
   var image_file_td_upload = image_file_td.childElements()[2];
   if(image_file_td_preview.childElements().length != 0){
      image_file_td_preview.childElements()[0].remove("value");
      image_file_td.childElements()[2].value = "";
   }
   image_file_td_preview.id = "exam_question_choice_photo_path" + choices_tr_no;
   //image_file_td_upload.remove("file");
   image_file_td_upload.writeAttribute('onchange',
      'this.form.action = "/admin/exam/exam_question_choice_preview/'+choices_tr_no+'";this.form.submit();')
   image_file_td_upload.id = 'file'+ choices_tr_no;
   image_file_td_upload.name = 'file' + choices_tr_no;
   //    a.childElements()[3].childElements()[2].onchange = "this.form.action = '/admin/exam/exam_question_choice_preview/\""+ l +"\"';this.form.submit();"
   //$$('#' + table_id + ' tbody')[0].insert(new_tr);
   $(table_id).insert(new_tr, {
      position: 'bottom'
   })
   answer_sort(table_id);
}

//add by zq 20120216
//function exam_image_preview(that, preview_id){
//    //var full_preview_id = 'exam_question_choice_photo_path'+preview_id;
//    that.form.action = "/admin/exam/exam_question_choice_preview/"+preview_id ;
//    that.form.submit();
//}

//add by zyc 20110623
//edit by zq 20120330
function answer_sort(table_id){
   var sort = 1
   $$('#' + table_id +' tr td.sort').each(function(item){
      // sort NO
      item.innerHTML = sort++;
      //画像ファイル
      var image_file_td = item.parentNode.childElements()[3]
      var image_file_td_preview = image_file_td.childElements()[0];
      var image_file_td_upload = image_file_td.childElements()[2];
      image_file_td_preview.id = "exam_question_choice_photo_path" + (sort-1);
      //image_file_td_upload.remove("file");
      image_file_td_upload.writeAttribute('onchange',
         'this.form.action = "/admin/exam/exam_question_choice_preview/'+(sort-1)+'";this.form.submit();')
      image_file_td_upload.id = 'file'+ (sort-1);
      image_file_td_upload.name = 'file' + (sort-1);
   })
}
//add by zyc 20110623
function delete_answer(answer, table_id){
   if($$('#choices tr').size() != 2){
      answer.parentNode.parentNode.remove();
      answer_sort(table_id);
   }else
   {
      alert("選択肢を削除することが出来ません。");
   }

}



function small_question_type1(type){
   switch(type){
      case "1":
         $("pg1").show();
         $("pg2").hide();
         $("question_type_tip1").hide();
         break
      case "2":
         $("pg1").hide();
         $("pg2").show();
         $("question_type_tip1").hide();
         break
      case "":
         $("question_type_tip1").show();
         break
   }
}

function small_question_type2(type){
   switch(type){
      case "1":
         $("pg3").show();
         $("pg4").hide();
         $("question_type_tip2").hide();
         break
      case "2":
         $("pg3").hide();
         $("pg4").show();
         $("question_type_tip2").hide();
         break
      case "":
         $("question_type_tip2").show();
         break
   }
}
function select_change(obj)
{
   if(obj.checked){
      $(obj).next().writeAttribute('value', 'true');
   }else
   {
      $(obj).next().writeAttribute('value', 'false');
   }
}
