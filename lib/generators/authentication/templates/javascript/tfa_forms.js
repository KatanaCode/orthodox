// Basic JS functionality for one-time-password form. Designed to be used with jQuery and 
// Bootstrap.
//
// Automatically generated by the orthodox gem (https://github.com/katanacode/orthodox)
// (c) Copyright 2019 Katana Code Ltd. All Rights Reserved. 
  
// Initialize method called when jQuery ready
function init() {
  $("body").on("click", ".js-tfa-link", onClick);
}

// Callback when toggle links are clicked. Shows/hides form fields and links
function onClick(e){
  e.preventDefault();
  $(".js-tfa-link").toggleClass("d-none");
  $(".js-tfa-field-group").toggleClass("d-none");
}

jQuery(init);