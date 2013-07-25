function check_free_course_selected(flag){
    if(flag)
    {
        $("associated_course").show();
        $("associated_course_a").show();
        $("course_pay_type").options[0].selected = true;
    }else{
        $("associated_course").hide();
        $("associated_course_a").hide();
    }
}

function check_pay_method_checked(v){
    if(v != "0")
    {
        $("course_pay_flag").checked = false;
        $("associated_course").hide();
        $("associated_course_a").hide();
    }
}

function record_course_id(item){
    if(item.checked){
        $('pay_course').value = item.value;
    }else
    {
        $('pay_course').value = '';
    }
}