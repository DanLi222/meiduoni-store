$(function () {
    $(document).ready(function(){
        $('#productColorPicker').on('change', function () {
            $.ajax({
                url: "",
                contentType: 'text/html',
                type: "GET",
                data: {product_id: this.value},
                success: function(data){
                    $('#product_detail').html(data);
                }
            });
        });
    });
});

