$(document).ready(function () {

    // Make AJAX request to get items and populate select options
    $.ajax({
        url: itemsUrl,
        dataType: 'json',
        success: function (data) {
            var options = '';
            for (var i = 0; i < data.length; i++) {
                options += '<option value="' + data[i].id + '">' + data[i].Nome + '</option>';
            }
            $('.item-select').append(options);
        },
        error: function () {
            alert('Error getting items.');
        }
    });

    // Add row
    $("#addRow").click(function () {

        var html = '<tr>' +
            '<td>' +
            '<select class="form-control item-select" name="item[]">' +
            '<option value="">Select Item</option>' +
            '</select>' +
            '</td>' +
            '<td><input type="number" class="form-control quantity" name="quantity[]" placeholder="Enter quantity"></td>' +
            '<td><input type="text" step="0.01" class="form-control price" name="price[]" placeholder="Enter price per unit"></td>' +
            '<td><button type="button" class="btn btn-danger delete-row">Delete</button></td>' +
            '</tr>';
        $("#inputTable tbody").append(html);

        // Make AJAX request to get items and populate select options in the new row
        $.ajax({
            url: itemsUrl,
            dataType: 'json',
            success: function (data) {
                var options = '';
                for (var i = 0; i < data.length; i++) {
                    options += '<option value="' + data[i].id + '">' + data[i].Nome + '</option>';
                    console.log(data[i].Nome)
                }
                $('.item-select:last').append(options);
            },
            error: function () {
                alert('Error getting items.');
            }
        });
    });

    // Delete row
    $(document).on("click", ".delete-row", function () {
        $(this).closest("tr").remove();
    });

    // Validate form
    $("form").submit(function (event) {
        var isValid = true;
        $(".item-select").each(function () {
            if ($(this).val() == "") {
                $(this).addClass("is-invalid");
                isValid = false;
            } else {
                $(this).removeClass("is-invalid");
            }
        });
        $(".quantity").each(function () {
            if ($(this).val() == "" || $(this).val() <= 0) {
                $(this).addClass("is-invalid");
                isValid = false;
            } else {
                $(this).removeClass("is-invalid");
            }
        });
        $(".price").each(function () {
            if ($(this).val() == "" || $(this).val() <= 0) {
                $(this).addClass("is-invalid");
                isValid = false;
            } else {
                $(this).removeClass("is-invalid");
            }
        });
        if (!isValid) {
            event.preventDefault();
        }
    });
});
