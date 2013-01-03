
var geocoder = new GClientGeocoder();

document.observe('dom:loaded', function() {
  var address_input = $('address');

  $('address_form').observe('submit', function(event) {
    var address = address_input.value;
    geocoder.getLatLng(
      address,
      function(point) {
        if (!point) {
          alert(address + " not found");
        } else {
          $('lat').value = point.lat();
          $('lng').value = point.lng();
          $('lat_lng_form').request({onFailure:function(request){alert('Address not found')}});
        }
      }
    );
    Event.stop(event);
  });

  $('clear').observe('click', function() {
    address_input.value = '';
    address_input.focus();
  });

  address_input.focus();
});