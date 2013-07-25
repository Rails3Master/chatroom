/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

window.onload = function(){
    if ($("user_backgroud_flag_1").checked){
        $("social1").style.display = 'none';
        $("social2").style.display = 'none'
        $("student1").style.display = ''
        $("student2").style.display = ''
        $("student3").style.display = ''
    }
   
    $("user_backgroud_flag_1").onclick=function(){
        $("social1").style.display = 'none';
        $("social2").style.display = 'none'
        $("student1").style.display = ''
        $("student2").style.display = ''
        $("student3").style.display = ''
    }
    $("user_backgroud_flag_2").onclick=function(){
        $("social1").style.display = '';
        $("social2").style.display = ''
        $("student1").style.display = 'none'
        $("student2").style.display = 'none'
        $("student3").style.display = 'none'
    }

}
