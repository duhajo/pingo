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

$ ->
  $("#workers-filter .place-list a").click ->
    skill = $("#request-params #skill").val()
    name = $("#request-params #name").val()
    if city = $("#request-params #city").val() == this.name
      city = ""
      $(this).removeClass 'active'
    else
      city = this.name
      $(this).addClass 'active'
    $.ajax
      type: "get"
      data:
        skill: skill,
        city: city,
        name: name
      dataType: 'script'
    false

  $("#workers-filter .tag-list a").click ->
    city = $("#request-params #city").val()
    name = $("#request-params #name").val()
    skill = $("#request-params #skill").val()
    if skill == ""
        skill = @name
        $(this).addClass 'active'
    else
      if skill.indexOf(@name) > -1
        skill = skill.replace(@name,'').trim()
        $(this).removeClass 'active'
      else
        skill = new Array(skill, @name )
        $(this).addClass 'active'

    $.ajax
      type: "get"
      data:
        skill: skill,
        city: city,
        name: name
      dataType: 'script'
    false

  $("#users-search #name").keyup ->
    city = $("#request-params #city").val()
    skill = $("#request-params #skill").val()
    $.ajax
      type: "get"
      data:
        skill: skill,
        city: city,
        name: this.value
      dataType: 'script'
    false
return
