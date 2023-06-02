$(function () {

    $('#image-button-shown').click(function () {
        $('#photo').click();
    });

    $('#photo').change(function () {
        $('#image-text').html($('#photo').val().split('\\').pop());
    });

    $('#photo').on('input', function () {
        var img = new Image();
        img.onload = function () {
            $('#output').attr('src', img.src);
        };
        img.src = URL.createObjectURL(this.files[0]);
    });


});