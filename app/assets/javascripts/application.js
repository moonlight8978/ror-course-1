// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require rails-ujs
//= require axios/dist/axios.min
//= require jquery/dist/jquery.min
//= require popper.js/dist/umd/popper.min
//= require @fortawesome/fontawesome-free/js/all.min
//= require materialize-css/dist/js/materialize.min
//= require chart.js/dist/Chart.min
//= require_tree .

$(document).ready(() => {
  M.AutoInit()
  $('.input-with-counter').characterCounter()
})
