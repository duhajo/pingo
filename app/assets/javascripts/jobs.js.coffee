$(document).ready ->
  $(".open-popup-link").magnificPopup type: "inline", midClick: true
  hasRight = $("#job-status").hasClass("rights")
  if hasRight
    init_status = ->
      $("#status-open").click ->
        $.ajax(
          url: "/jobs/"+$('#job').data('id')+"/set_status"
          data:
            status: 2
        ).success (data) ->
          $("#job-status").html data
          init_status()
        false

      $("#status-in-work").click ->
        $.ajax(
          url: "/jobs/"+$('#job').data('id')+"/set_status"
          data:
            status: 3
        ).success (data) ->
          $("#job-status").html data
          $(".actions").css "display", "none"
          init_status()
        false

      $("#status-closed").click ->
        $.ajax(
          url: "/jobs/"+$('#job').data('id')+"/set_status"
          data:
            status: 1
        ).success (data) ->
          $("#job-status").html data
          $(".actions").css "display", "block"
          init_status()
        false
    init_status()

  $("#like-button").click ->
    $.ajax(
      type: "PUT"
      url: "/jobs/"+$('#job').data('id')+"/like"
    ).success (data) ->
      if data == 1
        $("#likes").css "display", "block"
      if data == 0
        $("#likes").css "display", "none"
      $(".likes-number").html data
    false
  $(".likes-button").click ->
    likeButton = $(this)
    $.ajax(
      type: "PUT"
      url: "/jobs/"+likeButton.data('id')+"/like"
    ).success (data) ->
      if data == 1
        likeButton.parent().find(".likes-number").css "display", "block"
        likeButton.removeClass "no-votes"
      if data == 0
        likeButton.parent().find(".likes-number").css "display", "none"
        likeButton.addClass "no-votes"
      likeButton.parent().find(".likes-number").html data
      if likeButton.hasClass("voted")
        likeButton.removeClass "voted"
      else
        likeButton.addClass "voted"
    false
  $('a[rel=tipsy]').tipsy({gravity: 's', opacity: 1})

@initMap = (long, lat, zoom) ->
  map = new OpenLayers.Map("map")
  map.addLayer new OpenLayers.Layer.OSM()
  projection_wgs = new OpenLayers.Projection("EPSG:4326") # WGS 1984
  projection_smp = new OpenLayers.Projection("EPSG:900913") # Spherical Mercator
  position = new OpenLayers.LonLat(long, lat).transform(projection_wgs, projection_smp)
  markers = new OpenLayers.Layer.Markers("Markers")
  map.addLayer markers
  markers.addMarker new OpenLayers.Marker(position)
  map.setCenter position, zoom
  map

@showDeadline = () ->
  $("#show-deadline-link").hide()
  $("#deadline-field").show()

@showPlace = () ->
  $("#show-place-link").hide()
  $("#place-field").show()

@sendForm = (formId) ->
  $("#"+formId).submit()
