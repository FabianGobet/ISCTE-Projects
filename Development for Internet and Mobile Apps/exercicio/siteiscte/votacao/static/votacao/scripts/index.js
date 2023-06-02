$(function(){

    $('#toggle-questions-list').click(function(){
        var $questionList = $('#questions-list');
        $questionList.toggle();
        $(this).html($questionList.is(":hidden") ? "Mostrar questões" : "Esconder questões");
    });

    var slider = tns({
        slideBy: 'page',
        autoplay: true, 
        center: true, 
        controls: false, 
        nav: false, 
        autoplayButtonOutput: false, 
        autoplayTimeout: 2000
      });

});