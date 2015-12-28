$(document).ready ->

  $("#jobs-search #name").keyup ->
    $.ajax(
      type: "get"
      data:
        scope: $(this).data("scope"),
        jobs_filter: @value
    ).success (data) ->
      newFilterContent = $(data).find("#list-jobs")
      $("#list-jobs").html newFilterContent.html()
    false
  return

  $('.gallery-item').magnificPopup
    type: 'image'
    gallery: enabled: true

  $(".open-popup-link").magnificPopup type: "inline", midClick: true

  hasRight = $(".job-status").hasClass("rights")
  if hasRight
    init_status = ->
      $(".status-open").click ->
        $.ajax(
          url: "/jobs/"+$('#job-view').data('id')+"/set_status"
          data:
            status: 2
        ).success (data) ->
          $("#job-status-wrapper").html data
          init_status()
        false

      $(".status-in-work").click ->
        $.ajax(
          url: "/jobs/"+$('#job-view').data('id')+"/set_status"
          data:
            status: 3
        ).success (data) ->
          $("#job-status-wrapper").html data
          init_status()
        false

      $(".status-closed").click ->
        $.ajax(
          url: "/jobs/"+$('#job-view').data('id')+"/set_status"
          data:
            status: 1
        ).success (data) ->
          $("#job-status-wrapper").html data
          init_status()
        false
    init_status()

@setJobType = (element, counterElem, value) ->
  $('#job_type').val(value);
  if !$(element).hasClass "active"
    $(element).addClass "active"
    counterElem.removeClass "active"

@showDeadline = () ->
  $("#show-deadline-link").hide()
  $("#deadline-field").show()

@showLocation = () ->
  $("#show-location-link").hide()
  $("#location-field").show()

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

@setClass = (container, newClass) ->
  if !container.hasClass newClass
    container.addClass newClass
  else
    container.removeClass newClass
