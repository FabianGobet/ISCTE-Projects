$(function(){

    var words = ['Abécula', 'Abentesma', 'Achavascado', 'Alimária', 'Andrajoso', 'Barregã', 'Biltre', 'Cacóstomo', 'Cuarra', 'Estólido', 'Estroso', 'Estultilóquio', 'Nefelibata', 'Néscio', 'Pechenga', 'Sevandija', 'Somítico', 'Tatibitate', 'Xexé', 'Cheché', 'Xexelento'];

    $('#validate-comment').click(function(){
        var $input = $('#comment-input');
        var $commentStatus = $('#comment-status');
        for(var w of words){
            if($input.val().toLowerCase().indexOf(w.toLowerCase()) != -1){
                $input.val('');
                $commentStatus.html('');
                return;
            }else {
                $commentStatus.html('Comentário aceite');
            }
        }
    });
});