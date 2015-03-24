//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.tokeninput
$(function() {
    $(".datepicker").datepicker({
        dateFormat: "yy-mm-dd"
    });
    $(".clear_filters_btn").click(function() {
        window.location.search = "";
        return false;
    });
    return $(".dropdown_button")
});
