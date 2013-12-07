@addManager = (element) ->
  list = $("#job_manager_ids")
  managerList = list[0].value.split(",")
  for manager in managerList
    if(element != parseInt(manager))
      managerList.push(element)
      list[0].value = managerList
      $.ajax(
          url: "/jobs/"+$('#job-manager-list').data('id')+"/edit_manager_list"
          data:
            user_id: element,
            remove: false
        ).success (data) ->
          initAutocomplete()
      break
      return false
    else
      break
      return false

@removeManager = (element) ->
  list = $("#job_manager_ids")
  managerList = list[0].value.split(",")
  for manager in managerList
    if(element == parseInt(manager))
      managerList.remove(element)
      list[0].value = managerList
      $.ajax(
          url: "/jobs/"+$('#job-manager-list').data('id')+"/edit_manager_list"
          data:
            user_id: element,
            remove: true
        ).success (data) ->
          initAutocomplete()

$(document).on $.modal.AJAX_COMPLETE, (event) ->
  if(event.target.id == "show-map-button")
    mapButton = $("#show-map-button")
    initMap(mapButton.data('long'), mapButton.data('lat'), 13)

$(document).ready ->
  $("#edit-manager-button").click (e) ->
    $.get @href, (html) ->
      initAutocomplete()

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
          $("#job-status-container").html data
          init_status()
        false

      $("#status-in-work").click ->
        $.ajax(
          url: "/jobs/"+$('#job').data('id')+"/set_status"
          data:
            status: 3
        ).success (data) ->
          $("#job-status-container").html data
          $("#actionbar .actions").css "display", "none"
          init_status()
        false

      $("#status-closed").click ->
        $.ajax(
          url: "/jobs/"+$('#job').data('id')+"/set_status"
          data:
            status: 1
        ).success (data) ->
          $("#job-status-container").html data
          $("#actionbar .actions").css "display", "block"
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

@sendForm = (formClass) ->
  $("form."+formClass).submit()

@initAutocomplete = () ->
    $('.user_with_autocomplete').autocomplete
      minLength: 2
      source: (request, response) ->
        $.ajax
          url: $('.user_with_autocomplete').data('autocompleteurl')
          dataType: "json"
          data:
            name: request.term
          success: (data) ->
            response(data)
      select: (event, ui) ->
        if(ui.item)
          addManager(ui.item.id)

Array::remove = (from, to) ->
  rest = @slice((to or from) + 1 or @length)
  @length = (if from < 0 then @length + from else from)
  @push.apply this, rest