

$('#info').hide()

$('button.btn').on('click',function(){
  $('#info').delay(1000).slideDown()
});



// var greeting = $('#greeting');
// var currentTime = new Date();
// var hourNow = currentTime.getHours();
// var msg;
// if (hourNow > 18) {
//   msg = 'Have a great evening!'
// } else if (hourNow > 12) {
//   msg = 'Enjoy the rest of your day!'
// } else if (hourNow > 0) {
//   msg = 'Have a great morning!'
// } else {
//   msg = 'Enjoy the website!'
// }
//
// greeting.html(msg).addClass('test').hide().delay(1000).slideDown(1000)
