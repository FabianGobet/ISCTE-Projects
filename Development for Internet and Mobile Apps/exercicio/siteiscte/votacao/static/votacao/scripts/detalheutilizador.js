$(function(){

   var $image = $('#profile-image');
   var $profileDetails = $('#profile-details');

   /*$image.mouseleave(function(){
      $profileDetails.hide();
   });

   $image.mouseenter(function(){
      $profileDetails.show();
   });*/

   $image.hover(function(){
      $profileDetails.toggle();
   });
   
});