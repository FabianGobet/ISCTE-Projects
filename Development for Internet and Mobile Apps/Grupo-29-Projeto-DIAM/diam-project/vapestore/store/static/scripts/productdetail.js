$(function(){
    $('#quantity').change(function(){
        $('#total').html((Number($(this).val()) * Number($('#price').data('price'))) + " €");
    });


    $('#add-cart').click(function(){
        if($('#quantity').val() == '' || $('#quantity').val() == '0'){
            $('#quantity').addClass('is-invalid');
        }else {
            $('#quantity').removeClass('is-invalid');
            window.open('/store/addtocart/' + $(this).data('product') + "/" + $('#quantity').val(), '_self')
        }
    });
});