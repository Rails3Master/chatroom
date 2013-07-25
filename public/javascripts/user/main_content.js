/**
 * Created with JetBrains RubyMine.
 * User: phw
 * Date: 13-7-16
 * Time: 上午8:25
 * To change this template use File | Settings | File Templates.
 */

function showOperating(id){
    var arr = $(id).getElementsByClassName("_cwABShowArea actionArea");
    var mouseOver = $(id).getElementsByClassName("_chatTimeLineMessageBox chatTimeLineMessageInner");
    mouseOver[0].className = "_chatTimeLineMessageBox chatTimeLineMessageInner chatTimeLineMessageHover" ;
    //显示操作
    var operating = $(id).getElementsByClassName("_cwABShowArea actionArea")
    operating[0].style.display = "block" ;
    //arr[0].display = "block" ;
}

function clearOperating(id){
    var mouseOut = $(id).getElementsByClassName("_chatTimeLineMessageBox chatTimeLineMessageInner chatTimeLineMessageHover");
    if (!(typeof mouseOut[0] == "undefined")) {
        mouseOut[0].className = "_chatTimeLineMessageBox chatTimeLineMessageInner";
    }
    var operating = $(id).getElementsByClassName("_cwABShowArea actionArea")
    operating[0].style.display = "none" ;
}

/**
 * 显示表情
 */
function showEmoticonList(){
   $("_emoticonList").style.display = "block" ;
}

function addEmoticonToMessage(obj) {
    var alt = obj.getElementsByTagName("img")[0].getAttribute('alt');
    $("_chatText").focus();
    $('_chatText').value += alt;
    $("_emoticonList").style.display = "none";
}

/**
 * 更新表情底部信息
 */
function updateBottom(obj){
    $("_emoticonDescription").innerHTML =obj.getElementsByTagName("img")[0].getAttribute('title')+obj.getElementsByTagName("img")[0].getAttribute('alt')
}
function updateBottomDefault(){
   $("_emoticonDescription").innerHTML = "请选择表情";
}

/*
发送消息
 */
function send_message(){
    var chat_text = $('_chatText').value;
    $('_chatText').value = "";
    if (!( chat_text == "") ){
         new Ajax.Request("/chat/send_message?chat_text="+chat_text,{
             onComplete: function(rsp){
                 var response = rsp.responseText.evalJSON();
                 //遍历每一条消息
                 for(var i =0;i<response.messages.length;i++){
                    var msg = response.messages[i].message;
                    var msg_user = response.users[i].user
                    //组装html加入
                    var  msg_html = assemblyMsgToHtml(msg,response.current_user.user,msg_user);
                    //讲组装好的消息显示到页面上
                     $("_timeLine").insert(msg_html);
                 }
                 //滚动条始终在最下方
                 var obj = document.getElementById("_timeLine");
                 obj.scrollTop= obj.scrollHeight;
             }
         });
    }else{
        return;
    }
}

/**
 * 组装消息显示的html
 * @param msg
 */
function assemblyMsgToHtml(msg,current_user,msg_user){
   var msg_html = '<div id="_messageId' + msg.id + '" data-rid="'+ msg.id + '" data-mid="'+ msg.id + '>" ' +
       'class="_message chatTimeLineMessage chatTimeLineMessageAnim clearfix chatTimeLineMessageMine"' +
       'onmouseover="showOperating(this.id)" onmouseout="clearOperating(this.id)">' +
       ' <div class="_chatTimeLineMessageBox chatTimeLineMessageInner">' +
       '<div class="_speaker avatarSpeaker">' +
       //图片还需处理
       '<img class=" _avatarHoverTip _avatarClickTip avatarClickTip avatarMedium _avatar _avatarAid'+ msg.id +
       '" data-aid="' + msg.id + '" src="/user/images/162528.rsz.jpg">' +
       '</div><div class="chatTimeLineMessageArea clearfix"><div class="chatTimeLineItemHeader autotrim">'+
       '<p class="_speakerName chatName"><span class="_nameAid'+ msg.id  + '">'+msg_user.name + '</span></p>'+
       '<p class="chatNameOrgname"><span class="cw_onm534538"></span></p>';      ////
   //解析内容
   var content = resolveContent(msg.content);
   //添加内容
   msg_html +=  '</div> <pre>'+ content + '</pre></div>' + '<div class="_timeStamp timeStamp" data-deleted="0" data-tm="1369981052">'+
       msg.created_at + '</div></div><div class="_moveArrow chatTimeLineMoveArrow selected"></div>';  //事件未处理，操作未加

    //添加消息操作
    var op = addMsgOP(msg,current_user);
   msg_html += op;
   msg_html += '</div><br/>'
   return   msg_html;
}


function resolveContent(con){
   var iconTitle = ["微笑","悲伤","大笑","太好啦","吃惊","眨眼","哭","汗","嗯...","亲亲","傻瓜","害羞","什么什么?",
       "困","恋爱","不出声的笑","说话","打呵欠","吐","帅哥","宅男宅女","得意地笑","点头","摇头","苦笑","松口气","鼓掌"
       ,"鞠躬","知道啦！","肌肉","跳舞","摇滚！","恶魔","星星","爱心","花","爆竹","蛋糕","咖啡",
       "啤酒","握手","好的"]
    var iconName = ["smile","sad","more_smile","lucky","surprise","wink","tears","sweat","mumu","kiss",
    "tongueout","blush","wonder","snooze","love","grin","talk","yawn","puke","ikemen","otaku","ninmari","nod",
    "shake","wry_smile","whew","clap","bow","roger","muscle","dance","komanechi","devil","star","heart",
    "flower","cracker","cake","coffee","beer","handshake","yes"];
   // var emoticons = /\(:[a-zA-P]\)/.exec(con);
    var imgs = []
    var i = 0;
    while(con.match(/\(:[a-zA-P]\)/) != null){
        var rs = /\(:[a-zA-P]\)/.exec(con)+"";
        var index = rs.charCodeAt(2);
        if(index>=97&&index<=122){
             index = index - 97;
        }else{
             index = index -65 + 26
        }
        var img = '<img src="/user/images/emo_'+iconName[index]+'.gif" title="'+iconTitle[index]+'" alt="'+rs+'">'
        imgs[i] = img;
        i++;
        con  =  con.replace(/\(:[a-zA-P]\)/,"(#img)");   //(#img)表示表情的位置
        //alert(/\(#img\)/.exec("(#img)"));
    }
    //将表情加入内容
    for(i = 0;i<imgs.length;i++){
        con  =  con.replace(/\(#img\)/,imgs[i]);
    }
    return con
}

//添加消息操作
function addMsgOP(msg,current_user){
     var addMsgOp = ""
     if(msg.user_id == current_user.id){
         addMsgOp = '<div class="_cwABShowArea actionArea" style="display: none;">'+
             '<ul role="toolbar" class="_messageActionNav cwTextUnselectable actionNav">' +
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="quote">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">引用</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="task">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">Task</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="edit">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">编辑</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="link">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">链接</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext"></span></li>'+
             '</ul></div>'
     }else{
         addMsgOp = '<div class="_cwABShowArea actionArea" style="display: none;">'+
             '<ul role="toolbar" class="_messageActionNav cwTextUnselectable actionNav">' +
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="reply">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">回信</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="quote">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">引用</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="task">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">Task</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'" data-cwui-ab-type="link">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext">链接</span></li>'+
             '<li role="button" class="_cwABAction linkStatus" data-cwui-ab-id="' +msg.user_id +'">'+
             '<span class="icoFontActionQuote"></span>' + '<span class="_showAreaText showAreatext"></span></li>'+
             '</ul></div>'
     }
    return  addMsgOp;
}

/*
回车发送消息
 */
function Enter_send_message(obj){
    if (obj.keyCode == 13){
        obj.returnValue=false;
        obj.cancel = true;
        $("_sendButton").click();
    }
}

/**
 * 动态刷新消息列表
 */
//window.setInterval("refreshMessage()", 5000);
function refreshMessage(){
    new Ajax.Request("/chat/get_update_message", {
        onComplete: function(){
            //滚动条始终在最下方
            var obj = document.getElementById("_timeLine");
            obj.scrollTop= obj.scrollHeight;
        }
    });
}

/**
 * 显示添加任务
 */
function showTaskAddMeta(){
    $("_taskAddMeta").style.display ="block";
}

function hideAddTask(){
    $("_taskAddMeta").style.display ="none";
}

/**
 * 显示添加任务执行者
 */
function showSelectMember(){
    //new Ajax.Request("/task/show_select_member");
    //$("_taskAssignList").style.display = "block" ;
    new Ajax.Request("/task/show_select_member", {
        onComplete: function(){
            //将已被选择责任人打勾
            var executor =  document.getElementsByClassName("_taskAssignMemberLabel taskAssignContentText") ;
            for(var i=0;i<executor.length;i++){
               var obj = $("executorCheck"+executor[i].getAttribute("data-aid"));
                obj.setAttribute('aria-checked', 'true');
                obj.setAttribute('class', '_cwCB _contactPanelCheck _cwCBChecked ico15CheckboxActive');
            }
            $("_taskAssignList").style.display = "block" ;
        }
    });
}

/**
 *任务执行者的选择与取消
 */
function choose(obj){
    var flag = obj.getAttribute('aria-checked');
    //获取选中执行者信息
    var selected_li = obj.parentNode
    var user_id =  selected_li.getAttribute('data-cwui-lt-value');
    var user_name = $("executorName"+user_id).innerHTML;
    if(flag == 'false'){
        obj.setAttribute('aria-checked', 'true');
        obj.setAttribute('class', '_cwCB _contactPanelCheck _cwCBChecked ico15CheckboxActive');
        $("_inchargeEmpty").style.display = "none" ;
        // $$('span[role="listitem"][aria-checked="true"]')
        var insertText = '<span id = "showMember'+user_id+'" class="taskAssignContent taskAssignMember">'  +
            '<span class="_taskAssignMemberLabel taskAssignContentText" data-aid="' +
            user_id + '"><span class="_nameAid'+user_id+'">'+
            user_name + '</span></span><span class="_taskAssignCancel taskAssignContentCancel" data-aid="' + user_id +
            '"' + 'onclick = "cancelMember(this)"><span class="icoFontCancel" ></span><span class="icoTextHide">删除</span></span></span>';
        $("_assignBox").insert(insertText);
    }else{
        obj.setAttribute('aria-checked', 'false');
        obj.setAttribute('class', '_cwCB _contactPanelCheck _cwCBUnchecked ico15Checkbox');
        var del_id ="showMember"+ user_id;
        $(del_id).remove();
    }
}

/**
 * 取消负责人
 */
function cancelMember(obj){
    obj.parentNode.remove();
}

/**
 * 添加任务
 */
function addTask(){
    //获取任务信息
    var date = $('_limit_time').value;
    var content = $('_taskNameInput').value;
    var executor =  document.getElementsByClassName("_taskAssignMemberLabel taskAssignContentText") ;
    var user_ids = [];
    for(var i=0;i<executor.length;i++){
        user_ids[i] = executor[i].getAttribute("data-aid");
    }
    new Ajax.Request(
        "/task/add_task",
        {
            method: 'post',
            parameters: "user_ids="+user_ids+"&content="+content+"&date="+date ,
            onComplete: function(){
                $("_taskAddMeta").style.display ="none";
                $('_taskNameInput').value = "";
                $("_assignBox").innerHTML = "";
                $('_limit_time').value = "";
            }
        }
    );
}