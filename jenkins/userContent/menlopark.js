document.observe('dom:loaded', function() {
  setTimeout(function(){
    document.getElementById('search-box').setAttribute("type","search");
    document.getElementById('main-table').setAttribute("style","none");
  }, 500);
});
