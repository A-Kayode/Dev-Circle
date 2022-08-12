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
				$('#login_message').toggleClass('alert alert-danger');
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