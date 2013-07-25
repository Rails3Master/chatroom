// JavaScript Document
//add by zyc 20110623
//function add_answer(table_id){
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
// change by fsn 20111216
function add_answer(table_id){
    a = $$('#' + table_id + ' tr')[1].cloneNode(true);

    a.childElements()[1].childElements()[0].value = ''
    if(a.childElements()[2].childElements()[0].type == 'hidden')
    {
        a.childElements()[2].childElements()[0].value ='';
    }
    $$('#' + table_id + ' tbody')[0].insert(a);
    answer_sort(table_id);
}

//add by zyc 20110623
function answer_sort(table_id){
    var sort = 1
    $$('#' + table_id +' tr td.sort').each(function(item){
        item.innerHTML = sort++;
    })
}
//add by zyc 20110623
function delete_answer(answer, table_id)
{
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
        case "3":
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
        case "3":
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
