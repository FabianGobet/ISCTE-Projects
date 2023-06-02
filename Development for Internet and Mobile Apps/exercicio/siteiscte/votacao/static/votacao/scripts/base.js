$(function(){

    var $topBarImage = $('#profile-image-top-bar');

    $topBarImage.dblclick(function(){
        $(this).hide();
    });

    $('#profile-username-top-bar').click(function(){
        $topBarImage.show();
    });
})