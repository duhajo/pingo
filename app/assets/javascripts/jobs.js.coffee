$(document).ready ->
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
  $('a[rel=tipsy]').tipsy({gravity: 's', opacity: 1})