$(function(){
    $('.card').click(function(){
        window.open($(this).data("url"), '_self');
    });
});