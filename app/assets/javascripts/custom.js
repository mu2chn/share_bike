document.addEventListener('turbolinks:click', function(){
    $toggle = $(document.window);
    $('html').removeClass('nav-open');
    nowuiKit.misc.navbar_menu_visible = 0;
    $('#bodyClick').remove();
    setTimeout(function() {
        $toggle.removeClass('toggled');
    }, 250);
    $('#myModal').modal('hide')

});
