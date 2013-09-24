directionsDisplay = undefined
directionsService = undefined
full_destination = undefined
geocoder_one_results = undefined
map = undefined
directionsDisplay = undefined
directionsService = new google.maps.DirectionsService()
map = undefined
geocoder_one_results = undefined
full_destination = undefined
$(document).ready ->
  calcRoute = undefined
  createMarker = undefined
  getLatLong_destination = undefined
  getLatLong_origin = undefined
  infowindow = undefined
  initialize = undefined
  initialize = ->
    control = undefined
    mapOptions = undefined
    directionsDisplay = new google.maps.DirectionsRenderer()
    mapOptions =
      zoom: 7
      mapTypeId: google.maps.MapTypeId.ROADMAP
      center: new google.maps.LatLng(40.6700, -73.9400)

    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
    directionsDisplay.setMap map
    directionsDisplay.setPanel document.getElementById("directions-panel")
    control = document.getElementById("control")
    map.controls[google.maps.ControlPosition.TOP_CENTER].push control

  calcRoute = (start, end) ->
    request = undefined
    request =
      origin: start
      destination: end
      travelMode: google.maps.DirectionsTravelMode.DRIVING

    directionsService.route request, (response, status) ->
      if status is google.maps.DirectionsStatus.OK
        $("#drive_time").val response.routes[0].legs[0].duration.value
        directionsDisplay.setDirections response


  createMarker = (latlng, name, html) ->
    contentString = undefined
    marker = undefined
    latlng = latlng[0].geometry.location
    contentString = html
    marker = new google.maps.Marker(
      position: latlng
      map: map
      zIndex: Math.round(latlng.lat() * -100000) << 5
    )
    google.maps.event.addListener marker, "click", ->
      infowindow.setContent contentString
      infowindow.open map, marker

    google.maps.event.trigger marker, "click"
    marker

  getLatLong_destination = (address, callback) ->
    geo = undefined
    geo = new google.maps.Geocoder
    geo.geocode
      address: address
    , (results, status) ->
      callback results, "Destination Pin", "Destination"  if status is google.maps.GeocoderStatus.OK


  getLatLong_origin = (address, callback) ->
    geo = undefined
    geo = new google.maps.Geocoder
    geo.geocode
      address: address
    , (results, status) ->
      callback results, "Origin Location Pin", "Origin Location"  if status is google.maps.GeocoderStatus.OK


  infowindow = new google.maps.InfoWindow(size: new google.maps.Size(150, 50))
  $("#first form").bind "ajax:complete", ->
    d_street = undefined
    d_zip_code = undefined
    d_street = $(".to_street input").val()
    d_zip_code = $(".to_zip_code input").val()
    full_destination = d_street + d_zip_code
    getLatLong_destination full_destination, (geocoder_one_results, pin_caption, pin_caption_two) ->
      createMarker geocoder_one_results, pin_caption, pin_caption_two


  $("#second form").bind "ajax:complete", ->
    c_street = undefined
    c_zip_code = undefined
    full_origin_location = undefined
    c_street = $(".from_street input").val()
    c_zip_code = $(".from_zip_code input").val()
    full_origin_location = c_street + ", " + c_zip_code
    getLatLong_origin full_origin_location, (geocoder_one_results, pin_caption, pin_caption_two) ->
      createMarker geocoder_one_results, pin_caption, pin_caption_two

    calcRoute full_origin_location, full_destination

  google.maps.event.addDomListener window, "load", initialize
