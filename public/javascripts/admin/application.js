function genearteDateSelect(obj, valid_str, start_time, end_time, time_type){
    var valid_flag = true;
    if (valid_str != "" && valid_str != null) {
        valid_flag = valid_str;
    }
    if (start_time != null && end_time != null) {
        if (obj.id == $(start_time).id) {
            if ($F(end_time) == "" || $F(end_time) == null) {
                valid_flag = true;
            }
            else {
                valid_flag = 'date <= Date.parseFormattedString($F(end_time))';
            }
        }
        else 
        if ($F(start_time) == "" || $F(start_time) == null) {
            valid_flag = true;
        }
        else {
            valid_flag = 'date >= Date.parseFormattedString($F(start_time))';
        }
    }
    var strTimeFlag = "";
    if(time_type == 'time'){
        new CalendarDateSelect(obj, {
            time:'mixed',
            popup: 'force',
            valid_date_check: function(date){
                return eval(valid_flag)
            },
            year_range: [(new Date()).stripTime().getFullYear() - 100, (new Date()).stripTime().getFullYear() + 10]
        });
    }else{
        new CalendarDateSelect(obj, {
            popup: 'force',
            valid_date_check: function(date){
                return eval(valid_flag)
            },
            year_range: [(new Date()).stripTime().getFullYear() - 100, (new Date()).stripTime().getFullYear() + 10]
        });
    }
}


function checkbox_to_radio(obj){
    var flag = obj.checked;
    var class_name = obj.className;
    var array = $$("." + class_name);
    if(flag){
        for(var index=0; index<array.length; index++)
        {
            array[index].checked = false;
        }
        obj.checked = true;
    }
}


function mail_complete(live_id){
    $('send_mail_' + live_id).className="btn_send";
    $('send_mail_'+ live_id).disabled=false;
}
function mailing(live_id){
    $('send_mail_'+ live_id).className="btn_in_send";
    $('send_mail_'+ live_id).disabled=true;
}

function genearteLiveDateSelect(obj, valid_str, start_time, end_time, time_type){
   var valid_flag = true;
   if (valid_str != "" && valid_str != null) {
      valid_flag = valid_str;
   }
   if (!$('live_past').checked){
      var now_date = new Date();
      var year = now_date.getFullYear();
      var month = now_date.getMonth()+1;
      var day = now_date.getDate();
      var today = "";
      today = year + '-' + month + '-' + day;
      if (start_time != null && end_time != null) {
         if (obj.id == $(start_time).id) {
            if ($F(end_time) == "" || $F(end_time) == null) {
               valid_flag = 'date >= Date.parseFormattedString("'+today+'")';
            }
            else {
               valid_flag = 'date <= Date.parseFormattedString($F(end_time)) && date >= Date.parseFormattedString("'+today+'")';
            }
         }
         else
         if ($F(start_time) == "" || $F(start_time) == null) {
            valid_flag = 'date >= Date.parseFormattedString("'+today+'")';
         }
         else {
            valid_flag = 'date >= Date.parseFormattedString($F(start_time)) && date >= Date.parseFormattedString("'+today+'")';
         }
      }
   }else{
      if (start_time != null && end_time != null) {
         if (obj.id == $(start_time).id) {
            if ($F(end_time) == "" || $F(end_time) == null) {
               valid_flag = true;
            }
            else {
               valid_flag = 'date <= Date.parseFormattedString($F(end_time))';
            }
         }
         else
         if ($F(start_time) == "" || $F(start_time) == null) {
            valid_flag = true;
         }
         else {
            valid_flag = 'date >= Date.parseFormattedString($F(start_time))';
         }
      }
   }
   var strTimeFlag = "";
   if(time_type == 'time'){
      new CalendarDateSelect(obj, {
         time:'mixed',
         popup: 'force',
         valid_date_check: function(date){
            return eval(valid_flag)
         },
         year_range: [(new Date()).stripTime().getFullYear() - 100, (new Date()).stripTime().getFullYear() + 10]
      });
   }else{
      new CalendarDateSelect(obj, {
         popup: 'force',
         valid_date_check: function(date){
            return eval(valid_flag)
         },
         year_range: [(new Date()).stripTime().getFullYear() - 100, (new Date()).stripTime().getFullYear() + 10]
      });
   }
}