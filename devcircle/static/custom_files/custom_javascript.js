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


/* This code is used to submit posts */
function submit_post(gid, mid, token, path){
	var post= $('#devpost').val();
	var title= $('#post_title').val();
	var data2send= {'post':post, 'grp_id':gid, 'mem_id':mid, 'csrf_token':token, 'title':title};

	$.ajax({
		url:'/posts/ajax/submitpost/',
		type:'post',
		dataType:'json',
		data:data2send,
		success:function(rsp){
			if (rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				alert(rsp.message);
				var addpost= `<div class= "row whitebg mb-2"><div class= "col">`
				addpost += `<small>(image here) Written by You on ${rsp.post[4]}</small><h5>${rsp.post[2]}</h5><p>${rsp.post[3]}</p>`;
				if (path == '/landing/'){
					addpost += `<small>Group: ${rsp.post[1]}</small>`
				}
				addpost += `</div></div>`
				$('.post_container').prepend(addpost);

				$('#devpost').val("");
				$('#post_title').val("");
			}
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used for filtering all/available members on specific group page */
$(document).ready(function(){
	$('.mem_filter').click(function(){
		if( $('#all_mems_radio').prop('checked') == true ){
			$('.all_mems_row').prop('hidden', false);
			$('.avail_mems_row').prop('hidden', true);
		}else if( $('#avail_mems_radio').prop('checked') == true ){
			$('.all_mems_row').prop('hidden', true);
			$('.avail_mems_row').prop('hidden', false);
		}
	});
});


/* This code is used for calling up and populating the modal used for assigning projects. */
function assign_project_modal(gid, from, to, toname){
	$('#assignee_name').text(toname);
	$('#hidden_assign_details').val(`${gid} ${from} ${to}`);

	$('#assign_project_modal').modal('show');
}


/* This code is used for actually assigning the project */
function assign_project(gid, from, to, token){
	var title= $('#task_title').val();
	var desc= $('#task_desc').val();
	var num= $('#task_dur_num').val();
	var dur_type= $('#task_dur_type').val();

	if(title.trim() == "" || desc.trim() == "" || num == ""){
		alert("Cannot assign project till all fields are filled.");
	}else{
		var dur= Number(num) * Number(dur_type);

		 var data2send= {'grp_id':gid, 'from':from, 'to':to, 'csrf_token':token, 'title':title, 'desc':desc, 'dur':dur};

		 $.ajax({
		 	url:'/projects/ajax/assignproject/',
		 	data:data2send,
		 	type:'post',
		 	dataType:'json',
		 	success:function(rsp){
		 		if(rsp.status == 0){
		 			alert(rsp.message);
		 		}else if(rsp.status == 1){
		 			alert(rsp.message);

			 		$('#task_title').val("");
			 		$('#task_desc').val("");
			 		$('#task_dur_num').val("");
			 		$('#assign_project_modal').modal('hide');
		 		}
		 	},
		 	error:function(err){console.log(err);}
		 });
	}
}


/* This code is used to accept projects assigned to you */
function accept_project(tid, token, div_id, btn_id){
	$.ajax({
		url:'/projects/ajax/acceptproject/',
		data:{'task_id':tid, 'csrf_token':token},
		type:'post',
		dataType:'json',
		success:function(rsp){
			if(rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				var dead= `<p><b>Deadline: </b>${rsp.deadline}</p>`
				$(`#${div_id}`).append(dead);
				$(`#${btn_id}`).text('Acknowledged');
			}
			
		},
		error:function(err){console.log(err);}
	});
}



/* This code is used to show and hide projects that were assigned to you */
function show_proj_div(id){
	$('.proj_div').prop('hidden', true);
	$('#'+ id).prop('hidden', false);
}


/* This code is used to content projects that were assigned to you */
function contend_project(tid, token, div_id, btn_id){
	$.ajax({
		url:'/projects/ajax/contendproject/',
		data:{'task_id':tid, 'csrf_token':token},
		type:'post',
		dataType:'json',
		success:function(rsp){
			if(rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				$(`#${btn_id}`).prop('hidden', true);
				alert(rsp.message);
			}
			
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used to load the modal that gives information about the project being contended */
function contention_info(tid){
	$.ajax({
		url:'/projects/ajax/getcontentioninfo/',
		data:{'task_id':tid},
		type:'get',
		dataType:'json',
		success:function(rsp){
			if(rsp.status == 0){
				alert(rsp.message);
			}else if(rsp.status == 1){
				$('#proj_assignee').text(rsp.task[1]);
				$('#proj_assigner').text(rsp.task[0]);
				$('#proj_title').text(rsp.task[2]);
				$('#proj_duration').text(rsp.task[4] + ' days');
				$('#proj_description').text(rsp.task[3]);
				$('#contend_id').val(rsp.task[5]);

				$('#contention_vote_modal').modal('show');
			}
		},
		error:function(err){console.log(err);}
	});
}


/* This is used to do the actual voting on a project */
function voto_on_contention(cid, vote, token, vid){
	$.ajax({
		url:'/projects/ajax/voteoncontention/',
		data:{'contend_id':cid, 'vote':vote, 'csrf_token':token, 'voter':vid},
		type:'post',
		dataType:'json',
		success:function(rsp){
			if(rsp.status == 0 || rsp.status == 1){
				alert(rsp.message);
				$('#contention_vote_modal').modal('hide');
			}else if(rsp.status == 2){
				var mess= `${rsp.message}.\n Total Votes: ${rsp.tv}. Yes Votes: ${rsp.yv}. No Votes: ${rsp.nv}.`
				alert(mess);
				$('#contention_vote_modal').modal('hide');
			}
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used to activate the modal that will then be used to submit the project */
function submit_project_modal(tid, div_id){
	$('#submit_div_id').val(div_id);
	$('#submit_task_id').val(tid);
	$('#submit_project_modal').modal('show');
}


/* This code is used to submit the project that has been completed */
function submit_project(div_id){
	if($('#git_link').val()  == ''){
		alert("You must fill in link to your github where you have committed the project");
	}else{
		var form= document.getElementById('submit_project_form');
		var formdata= new FormData(form);

		$.ajax({
			url:'/projects/ajax/submit_project/',
			data:formdata,
			type:'post',
			dataType:'json',
			success:function(rsp){
				if(rsp.status == 0){
					alert(rsp.message);
				}else if(rsp.status == 1){
					alert(rsp.message);
					$('#'+ div_id).prop('hidden', true);
				}
			},
			error:function(err){console.log(err);},
			cache:false,
			processData:false,
			contentType:false
		});
	}
	
}


/* Code to retrieve information about correspondence and load it to send message modal */
function send_message_modal(user, dev_id){
	$.ajax({
		url:'/messages/ajax/retrievecorrespondence/',
		data:{"dev_id":dev_id},
		type:'get',
		dataType:'json',
		success:function(rsp){
			$('#correspondence_username').text(user);
			$('#corres_id').val(rsp.cid);
			if(rsp.status == 2){
				var msg= ""
				rsp.allcor.forEach((val,key)=>{
					msg += `<div class= "row mb-2">`;
					(val[0] == 1) ? msg += `<div class= "col sent_text">` : msg += `<div class= "col received_text">`;
					msg += `<p>${val[1]}</p><small><i>Sent: ${val[2]}</i></small></div></div>`;
				})
				$('#correspondence_messages').html(msg);	
			}else if(rsp.status == 1 || rsp.status == 3){
				$('#correspondence_messages').html("");
			}

			$('#send_messages_modal').modal('show');
			setTimeout(function(){
				var sh= $('#correspondence_messages').prop('scrollHeight');
				$('#correspondence_messages').scrollTop(sh);
			}, 200);
			
		},
		error:function(err){console.log(err);}
	});
}


/* This code is used to send messages to other users */
function send_message(){
	var form= document.getElementById('send_message_form');
	var formdata= new FormData(form);

	$.ajax({
		url:'/messages/ajax/sendmessage/',
		data:formdata,
		type:'post',
		dataType:'json',
		success:function(rsp){
			if(rsp.status == 1){
				var text= `<div class= "row mb-2"><div class= "col sent_text"><p>${$('#message_text').val()}</p><small><i>Sent: now</i></small></div></div>`;
				$('#correspondence_messages').append(text);
				$('#message_text').val("");
				setTimeout(function(){
					var sh= $('#correspondence_messages').prop('scrollHeight');
					$('#correspondence_messages').scrollTop(sh);
				}, 200);
			}
		},
		error:function(err){console.log(err);},
		cache:false,
		contentType:false,
		processData:false
	});
}


/* This code is used to add or remove rule input tags to the create group modal */
var rule_counter= 0;
function add_rule(){
	rule_counter++;
	var tag= `<div id = "rule_${rule_counter}"><label class= 'form-label'>Rule ${rule_counter}.</label><input type= "text" name= "group_rule" class= "form-control mb-1"></div>`
	$('#create_group_rule_container').append(tag);
	$('#remove_rule_btn').prop('hidden', false);
}
function remove_rule(){
	$('#rule_'+ rule_counter).remove();
	rule_counter--;
	if(rule_counter == 0){
		$('#remove_rule_btn').prop('hidden', true);
	}
}


/* This code checks whether a new group name is unique or not*/
function check_group_name(){
	var name= $('#group_name').val();

	$.ajax({
		url:'/groups/ajax/checkgroupname/',
		data:{'gname':name},
		dataType:'json',
		type:'get',
		success:function(rsp){
			if (rsp.status == 0){
				$('#group_name_check_message').css('color', 'red');
				$('#group_name_check_message').text('Group name is already taken');
				$('#create_group_form_submit_btn').prop('disabled', true);
			}else if(rsp.status == 1){
				$('#group_name_check_message').css('color', 'green');
				$('#group_name_check_message').text('Group name is valid');
				$('#create_group_form_submit_btn').prop('disabled', false);
			}
		},
		error:function(err){console.log(err);}
	});
}