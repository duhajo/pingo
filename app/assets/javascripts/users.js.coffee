# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@getLocation = ->
  success = (position) ->
    s = $("#status")
    # im FF wird die Funktion scheinbar mehrfach aufgerufen - einmal reicht
    return  if s.hasClass("success")
    $("#coordFields").show()
    $("#locationFields").hide()
    $("#openLocationFields").show()
    $("#radiusField").show()
    s.text "Deine Position konnte ermittelt werden!"
    s.addClass "success"
    $("#user_latitude").val position.coords.latitude
    $("#user_longitude").val position.coords.longitude
    navigator.geolocation.clearWatch watchId
    return
  error = (msg) ->
    $("#status").text = (if typeof msg is "string" then msg else "error")
    return
  if navigator.geolocation
    watchId = navigator.geolocation.getCurrentPosition(success, error)
  else
    $("#status").text = "Sorry your browser does not support geolocation."
  return

@getPositionManually = ->
  $("#locationFields").show()
  $("#openLocationFields").hide()
  $("#coordFields").hide()
  $("#radiusField").show()
  return

#ToDo: Complex combining filters
$ ->
  $("#workers-filter .place-list a").click ->
    $.ajax
      type: "get"
      data:
        city: this.name
      dataType: 'script'
    false

  $("#workers-filter .tag-list a").click ->
    $.ajax
      type: "get"
      data:
        skill: this.name
      dataType: 'script'
    false

  $("#users-search #search").keyup ->
    $.get $("#users-search").attr("action"), $("#users-search").serialize(), null, "script"
    false
return
