# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@initPlacesMap = ->
  L.mapbox.accessToken = 'pk.eyJ1IjoicHN5cGhhbnQiLCJhIjoiZ290ak5iYyJ9.bYZdC19qip0QBUtvrJ8r-Q'
  map = L.mapbox.map("map", "psyphant.nhm78mmc")

  $.getJSON "/places/index.json", (data) ->
    markers = new L.MarkerClusterGroup()

    $.each data, (key, val) ->
      marker = L.marker(new L.LatLng(val.latitude, val.longitude),
        icon: L.mapbox.marker.icon(
          "marker-symbol": "circle"
          "marker-color": "0044FF"
        )
        title: val.title
      )
      popupContent = val.title + '<br /><a class="btn btn-primary" href="'+val.url + '">Job anschauen' + '</a>'
      marker.bindPopup popupContent
      markers.addLayer marker
    map.addLayer markers