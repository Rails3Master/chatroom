// JavaScript Document

	load_subject_tab();
	load_homeroom_tab();
	load_library_tab();
	load_exam_tab();
	load_homework_tab();
	if(window.location.search == "?tab=student"){
		show_student_tab();
	}
	if(window.location.search == "?homeroom_edit_new_edit_tab"){

		show_homeroom_edit_tab();
		$('homeroom_new_title1').hide();
		$('homeroom_new_title2').show();
	}
	if(window.location.search == "?exam_detail"){
		show_exam_tab();

			$("exam_detail_tab").show();
			$("exam_list").hide();

	}
	if(window.location.search == "?homeroom_tab"){
		show_homeroom_tab();
	}
	if(window.location.search == "?homeroom_detail"){
		show_homeroom_tab();
		$("homeroom_list").hide();
		$("homeroom_detail").show();
	}
// these mothed is used to switch tab
//------------------

function show_subject_tab(){
	$("subject_tab").show();
	
	$("subject_list").show();
	$("subject_detail").hide();
	$("subject_new").hide();
	
	$("homeroom_tab").hide();
	$("library_tab").hide();
	$("exam_tab").hide();
	$("homework_tab").hide();
	$("student_tab").hide();
	
	tab_on(1);
}

function show_homeroom_tab(){
	$("subject_tab").hide();
	$("homeroom_tab").show();
	
	$("homeroom_list").show();
	$("homeroom_detail").hide();
	$("homeroom_new").hide();
	
	$('homeroom_new_title1').show();
	$('homeroom_new_title2').hide();
	
	$("library_tab").hide();
	$("exam_tab").hide();
	$("homework_tab").hide();
	$("student_tab").hide();

	tab_on(3);
}

function show_library_tab(){
	$("subject_tab").hide();
	$("homeroom_tab").hide();
	$("library_tab").show();
	
	$("library_list").show();
	$("library_new").hide();
	$("library_edit").hide();	
	
	$("exam_tab").hide();
	$("homework_tab").hide();
	$("student_tab").hide();

	tab_on(4);
}

function show_exam_tab(){
	$("subject_tab").hide();
	$("homeroom_tab").hide();
	$("library_tab").hide();
	$("exam_tab").show();
	
	$("exam_list").show();
	$("exam_student_list").hide();
	$("exam_detail_tab").hide();
	$("exam_sub_question_add").hide();
	$("exam_sub_question_edit").hide();
	$("exam_new").hide();
	
	
	$("homework_tab").hide();
	$("student_tab").hide();

	tab_on(5);
}

function show_homework_tab(){
	$("subject_tab").hide();
	$("homeroom_tab").hide();
	$("library_tab").hide();
	$("exam_tab").hide();
	$("homework_tab").show();
	
	$("homework_list").show();
	$("homework_new").hide();
	$("homework_edit").hide();
	
	$("student_tab").hide();

	tab_on(6);
}

function show_student_tab(){
	$("subject_tab").hide();
	$("homeroom_tab").hide();
	$("library_tab").hide();
	$("exam_tab").hide();
	$("homework_tab").hide();
	$("student_tab").show();
	
	tab_on(7);
}

function show_homeroom_edit_tab(){
	show_homeroom_tab();
	$("homeroom_list").hide();
	$("homeroom_new").show();
	
	tab_on(2);
}
//--------------------

//these mothed is used to contorl subject_tab action
//-----------------
function load_subject_tab(){
	$("subject1").onclick = function(){
		$("content1").toggle();
		if($("content1").getStyle('display') == "none"){
			//$("subject1_is_open").replace('<span id="subject1_is_open" style="margin-right: 50px;">+</span>');
			$("subject1").className = "";
		}else
		{
			//$("subject1_is_open").replace('<span id="subject1_is_open" style="margin-right: 50px;">-</span>');
			$("subject1").className = "active";
		}	
	};
	$("subject2").onclick = function(){
		$("content2").toggle();
		if($("content2").getStyle('display') == "none"){
			//$("subject2_is_open").replace('<span id="subject2_is_open" style="margin-right: 50px;">+</span>');
			$("subject2").className = "";
		}else
		{
			$("subject2").className = "active";
			//$("subject2_is_open").replace('<span id="subject2_is_open" style="margin-right: 50px;">-</span>');
		}	
	};
	$("subject3").onclick = function(){
		$("content3").toggle();
		if($("content3").getStyle('display') == "none"){
			$("subject3").className = "";
			//$("subject3_is_open").replace('<span id="subject3_is_open" style="margin-right: 50px;">+</span>');
		}else
		{
			$("subject3").className = "active";			
			//$("subject3_is_open").replace('<span id="subject3_is_open" style="margin-right: 50px;">-</span>');
		}	
	};
	$$(".course_detail").each(function(item){
	item.onclick = function(){
		$("subject_list").hide();
		$("subject_detail").show();
		};
	});
	$$(".course_new").each(function(item){
		item.onclick = function(){
			$("subject_list").hide();
			$("subject_new").show();
			};
	});
	load_course_new_tab();
	load_course_detail_tab();
}

function load_course_new_tab(){
	$$(".course_new_cancel").each(function(item){
		item.onclick = function(){
			$("subject_new").hide();
			$("subject_list").show();
			};
	});
	
	$$(".course_new_submit").each(function(item){
		item.onclick = function(){
			$("subject_new").hide();
			$("subject_detail").show();
			};
	});
}

function load_course_detail_tab(){
	$("subject_edit").onclick = function(){
		$("subject_detail_form").hide();
		$("subject_edit_form").show();
		$("subject_detail_btnbar").hide();
		$("subject_edit_btnbar").show();
	};
	$("course_edit_cancel").onclick = function(){
		$("subject_detail_form").show();
		$("subject_edit_form").hide();
		$("subject_detail_btnbar").show();
		$("subject_edit_btnbar").hide();
	};
	$("course_edit_submit").onclick = function(){
		$("subject_detail_form").show();
		$("subject_edit_form").hide();
		$("subject_detail_btnbar").show();
		$("subject_edit_btnbar").hide();
	};
	$("subject_detail_return").onclick = function(){
		$("subject_detail").hide();
		$("subject_list").show();
	}
}

//-----------------------

//these mothed is used to control homeroom_tab action
//-----------------------
function load_homeroom_tab(){
	$("homeroom_new_bt").onclick = function(){
		$("homeroom_list").hide();
		$("homeroom_new").show();	
	}
	/*$("homeroom_edit_bt").onclick = function(){
		$("homeroom_list").hide();
		$("homeroom_new").show();	
	}*/
	 $$(".homeroom_detail").each(function(item){
		item.onclick = function(){
			$("homeroom_list").hide();
			$("homeroom_detail").show();
			};
		})
	 $("homeroom_detail_cancel").onclick = function(){
		$("homeroom_list").show();
		$("homeroom_detail").hide()	
	}
	$("homeroom_new_cancel").onclick = function(){
		$("homeroom_list").show();
		$("homeroom_new").hide()	
	}
}
//-----------------------

//these mothed is used to control library_tab action
//-----------------------
function load_library_tab(){
	$$(".library_edit").each(function(item){
		item.onclick = function(){
			$("library_list").hide();
			$("library_edit").show();
			};
	})
	$("library_new_bt").onclick = function(){
		$("library_list").hide();
		$("library_new").show();	
	}
	$("library_edit_submit").onclick = function(){
		$("library_list").show();
		$("library_edit").hide();
	}
	$("library_edit_cancel").onclick = function(){
		$("library_list").show();
		$("library_edit").hide()	
	}
	$("library_new_submit").onclick = function(){
		$("library_list").show();
		$("library_new").hide()	
	}
	$("library_new_cancel").onclick = function(){
		$("library_list").show();
		$("library_new").hide()	
	}
}

//-----------------------

//these mothed is used to control exam_tab action
//-----------------------
function load_exam_tab(){
	$$(".exam_student_list_bt").each(function(item){
		item.onclick = function(){
			$("exam_list").hide();
			$("exam_student_list").show();
			};
	})
	$$(".exam_detail_bt").each(function(item){
		item.onclick = function(){
			$("exam_detail_tab").show();
			$("exam_list").hide();
			};
	})
	$("student_list_return_bt").onclick = function(){
		$("exam_list").show();
		$("exam_student_list").hide();
	}
	$("edit_exam_bt").onclick = function(){
		$("exam_detail").hide();
		$("exam_edit").show();
		
		$("exam_detail_btnbar").hide();
		$("exam_edit_btnbar").show();
		
	}
	$("exam_detail_return_bt").onclick = function(){
		$("exam_detail_tab").hide();
		$("exam_list").show();
	}
	$("exam_edit_confirm_bt").onclick = function(){
		$("exam_detail").show();
		$("exam_edit").hide();
		
		$("exam_detail_btnbar").show();
		$("exam_edit_btnbar").hide();

	}
	$("exam_edit_cancel_bt").onclick = function(){
		$("exam_detail").show();
		$("exam_edit").hide();
		
		$("exam_detail_btnbar").show();
		$("exam_edit_btnbar").hide();
	}
	$("exam_sub_question_add_bt").onclick = function(){
		$("exam_sub_question_add").show();
		$("exam_detail_tab").hide();
	}
	$("exam_question_add_submit_bt").onclick = function(){
		$("exam_sub_question_add").hide();
		$("exam_detail_tab").show();
	}
	$("exam_question_add_cancel_bt").onclick = function(){
		$("exam_sub_question_add").hide();
		$("exam_detail_tab").show();
	}
	
	
	$$(".exam_sub_question_edit_bt").each(function(item){
		item.onclick = function(){				
			$("exam_sub_question_edit").show();
			$("exam_detail_tab").hide();
		};
	})
	
	$("exam_question_edit_submit_bt").onclick = function(){
		$("exam_sub_question_edit").hide();
		$("exam_detail_tab").show();
	}
	$("exam_question_edit_cancel_bt").onclick = function(){
		$("exam_sub_question_edit").hide();
		$("exam_detail_tab").show();
	}
	
	$("exam_new_bt").onclick = function(){
		$("exam_list").hide();
		$("exam_new").show();
	}
}
//-----------------------

//these mothed is used to control homework_tab action
//-----------------------
function load_homework_tab(){
	$$(".homework_edit_bt").each(function(item){
		item.onclick = function(){
			$("homework_list").hide();
			$("homework_edit").show();
		};
	})
	$("homework_new_bt").onclick = function(){
		$("homework_list").hide();
		$("homework_new").show();	
	}
	$("homework_new_submit").onclick = function(){
		$("homework_list").show();
		$("homework_new").hide();	
	}
	
	$("homework_new_cancel").onclick = function(){
		$("homework_list").show();
		$("homework_new").hide();	
	}
	
	$("homework_edit_submit").onclick = function(){
		$("homework_list").show();
		$("homework_edit").hide();	
	}
	
	$("homework_edit_cancel").onclick = function(){
		$("homework_list").show();
		$("homework_edit").hide();	
	}
}

//-----------------------

function tab_on(index){
	for(var num = 1; num <= 7; num++)
	{
		if(num != index){
			$("tab_a" + num).className = "";
		}else
		{
			$("tab_a" + num).className = "on";
		}
	}
}