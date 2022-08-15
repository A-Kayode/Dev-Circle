/* This pertains to code to show or hide password on the signup or login modals */
$(document).ready(function(){
	$('.show_password').click(function(){
		$('.eye_icon').toggleClass('fa-eye');
		$('.eye_icon').toggleClass('fa-eye-slash');
		if( $('.password').attr('type') == 'password' ){
			$('.password').attr('type', 'text');
		}else{
			$('.password').attr('type', 'password');
		}
	});
});



/* This code is to send and receive information for logging in */
function login(){
	var form= document.getElementById('login_form');
	var formdata= new FormData(form);

	$.ajax({
		url:"/ajax/validatelogin/",
		data:formdata,
		dataType:"json",
		type:'post',
		success:function(rsp){
			if (rsp.status == 0){
				$('#login_message').addClass('alert alert-danger');
				$('#login_message').text(rsp.message);
			}else if (rsp.status == 1){
				$('#login_form').submit();
			}
		},
		error:function(err){ console.log(err) },
		cache:false,
		processData:false,
		contentType:false
	});
}



/* This code is used to save the languages choose by a developer */
function choose_language(dev_id, form_id){
	var form = document.getElementById(form_id);
	var formdata= new FormData(form);
	formdata.append("dev_id",dev_id);

	$.ajax({
		url:'/landing/ajax/savelanguages/',
		data:formdata,
		dataType:'json',
		type:'post',
		success:function(rsp){
			if (rsp.status == 1){
				console.log(rsp.glang);

				var grp_div= ""
				rsp.glang.forEach((val,key) => {
					grp_div += `<div class= "row whitebg m-1 select_group" onclick="get_info(${val[2]})"><div class= "col">`
					grp_div += `<h3>${val[0]}</h3><p>${val[1]}</p>`
					grp_div += `</div></div>`
				});

				$('#new_choose_group_col').html(grp_div);
				$('#new_choose_language').prop('hidden', true);
				$('#show_groups').prop('hidden', false);

			}
		},
		error:function(err){console.log(err);},
		cache:false,
		processData:false,
		contentType:false
	});
}


/* This code is used to retrieve the Information about a group when one is clicked from a list of recommended groups */
function get_info(id){
	data2send= {'grp_id':id};

	$.ajax({
			url:"/landing/ajax/getgroupinfo/",
		data:data2send,
		dataType:"json",
		type:"get",
		success:function(rsp){
			$('#ginfo_name').text(rsp.info[1]);
			$('#ginfo_desc').text(rsp.info[2]);
			$('#ginfo_type').text(`This is a ${rsp.info[3]} group`);
			$('#ginfo_link').attr('href', `/groups/${rsp.info[0]}/`);
			$('#ginfo_id').val(rsp.info[0]);
			$('#ginfo_join').attr('onclick', `join_group(${rsp.info[0]})`);
			$('#ginfo_leave').attr('onclick', `leave_group(${rsp.info[0]})`);

			if (rsp.memb == 0){
				$('#ginfo_join').removeClass('d-none');
				$('#ginfo_leave').addClass('d-none');
			}else{
				$('#ginfo_leave').removeClass('d-none');
				$('#ginfo_join').addClass('d-none');
			}

			var rule= ""
			rsp.rules.forEach((val, key)=>{
				rule += `<li>${val}</li>`
			});
			$('#ginfo_rules').html(rule);
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used to join groups */
function join_group(gid){
	$.ajax({
		url:'/groups/ajax/joingroup/',
		data:{'grp_id':gid},
		dataType:'json',
		type:'get',
		success:function(rsp){
			if(rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				$('#ginfo_join').toggleClass('d-none');
				$('#ginfo_leave').toggleClass('d-none');
			}
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used to leave groups */
function leave_group(gid){
	$.ajax({
		url:'/groups/ajax/leavegroup/',
		data:{'grp_id':gid},
		dataType:'json',
		type:'get',
		success:function(rsp){
			if(rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				$('#ginfo_join').toggleClass('d-none');
				$('#ginfo_leave').toggleClass('d-none');
			}
		},
		error:function(err){console.log(err);}
	});
}