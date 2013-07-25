/**
 * Created with JetBrains RubyMine.
 * User: fw
 * Date: 13-7-12
 * Time: 上午8:45
 * To change this template use File | Settings | File Templates.
 */
//document.write("<script language='javascript' src='javascripts/jquery-1.8.2.min.js'></script>");

function menuListTitleSelected(obj,chat_id,type){
    //修改选中好友样式
    if(type == "group"){
        var arr = document.getElementsByClassName("_roomLink _room roomUnread _roomSelected menuListTitleSelected");
        var arr1 = $("_roomListItems").getElementsByClassName("_roomLink _room _roomSelected menuListTitleSelected");
        if (!(typeof arr[0] == "undefined")) {
            arr[0].className = "_roomLink _room roomUnread";
        }
        if (!(typeof arr1[0] == "undefined")) {
            arr1[0].className = "_roomLink _room";
        }
        obj.className = "_roomLink _room roomUnread _roomSelected menuListTitleSelected";
    }else if(type == "user"){
        var arr = $("_roomListItems").getElementsByClassName("_roomLink _room _roomSelected menuListTitleSelected");
        var arr1 = document.getElementsByClassName("_roomLink _room roomUnread _roomSelected menuListTitleSelected");
        if (!(typeof arr[0] == "undefined")) {
            arr[0].className = "_roomLink _room";
        }
        if (!(typeof arr1[0] == "undefined")) {
            arr1[0].className = "_roomLink _room roomUnread";
        }
        obj.className = "_roomLink _room _roomSelected menuListTitleSelected";
    }

   //触发表单
   //document.getElementById("chat_id").value = chat_id
   //document.getElementById("chat_type").value =  type
  // $("show_chat").submit();
    //提交请求更新数据
    new Ajax.Request("/user/show_chat?chat_id="+chat_id+"&chat_type="+type, {
        onComplete: function(){
            //自适应页面大小（）
            setSideContent();
            //滚动条
            var obj = document.getElementById("_timeLine");
            obj.scrollTop= obj.scrollHeight;
        }
    });
}

/*
显示添加群组及联系人
 */
function addButton(){
    $("#_addButtonShow").attr({'style':'opacity: 1; z-index: 2; top: 79px; left: 189px;'});
}

function hideAddButtonShow(){
    $("#_addButtonShow").attr('style', 'display:none') ;
    $("#_taskAssignList").attr('style', 'display:none') ;
    $("#_emoticonList").attr('style', 'display:none') ;
}

/*
显示群组及联系人的添加页面
 */
function showAddContact(){
    //$("_contactWindowShow").style.display = "block" ;
    openWithSBox('/contacts/manage', 600, 800);
}

function hideContactWindow(){
//    $("_contactWindowShow").style.display = "none" ;
    $("#_contactWindowShow").attr('style', 'display:none') ;
}

/*
搜索联系人
 */
function selectUserByLike(val){
    //$("like_select").submit();
    //new Ajax.Request('/chat/like_select_user', {asynchronous:true, evalScripts:true, parameters:{condition:val}});
    //new Ajax.Request("/contact/search_user?condition="+val);
    $.ajax({url:"/contacts/search_user?condition="+val, dataType:'json'});
}

/**判断是不是有user被选中
 *
 * @param obj
 */
function user_selected(){
   //console.log($$('span[role="checkbox"][aria-checked="true"]').size()) ;
    if($$('span[role="checkbox"][aria-checked="true"]').size() > 0){
        $('#_contactWindowAdd').attr('class', '_contactWindowNavigationItem _button btnLarge _cwBN button btnPrimary');
        $('#_contactWindowAdd').attr('aria-disabled', 'false');
    }else{
        $('#_contactWindowAdd').attr('class', '_contactWindowNavigationItem _button btnLarge _cwBN button btnDisable');
        $('#_contactWindowAdd').attr('aria-disabled', 'true');
    }
}

/**
 *
 */
function change_status(obj){
    var flag = obj.getAttribute('aria-checked');
    if(flag == 'false'){
        obj.setAttribute('aria-checked', 'true');
        obj.setAttribute('class', '_cwCB _contactPanelCheck _cwCBChecked ico15CheckboxActive');
    }else{
        obj.setAttribute('aria-checked', 'false');
        obj.setAttribute('class', '_cwCB _contactPanelCheck _cwCBUnchecked ico15Checkbox');
    }
    user_selected();
}

/**  添加联系人
 *
 */
function add_friend(user_id){
    new Ajax.Request("/contact/add_friend?friend_id="+user_id, {
        onSuccess: function(rsp){
            text = rsp.responseText ;
            console.log('rsp text:'+text);
            delete_contact_li(text)
            if(rsp == 'OK'){

            }
        }
    });
}

/**删掉联系人的li
 * data_aid: user_id
 */
function delete_contact_li(data_aid){
   //console.log($$('li[data-aid="'+data_aid+'"]').size());
    $('li[data-aid="'+data_aid+'"]').each(function(item){
        $(item).remove();
    });
}