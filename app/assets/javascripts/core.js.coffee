@sendForm = (formClass) ->
  $("form."+formClass).submit()

# called from a bootstrap dropdown, this closes the dropdown
$('a[data-toggle=modal]').on 'click', ->
  $('.dropdown').removeClass('open')
# this sets up the ajax loader, and it will stay until the method specific js removes it
$('a[data-target=#ajax-modal]').on 'click', (e) ->
  e.preventDefault()
  e.stopPropagation();
  $.rails.handleRemote( $(this) );
#removes whatever is in the modal body content div upon clicking close/outside modal
$(document).on 'click', '[data-dismiss=modal], .modal-scrollable', ->
  $('.modal-body-content').empty()
$(document).on 'click', '#ajax-modal', (e) ->
  e.stopPropagation();
$(document).ready ->
  $('.show-tooltip').tooltip();
  $('.datepicker').datepicker
    format: "yyyy-mm-dd"
    todayHighlight: true

$("#search-input").bind "railsAutocomplete.select", (event, data) ->
  window.location.replace "/jobs/"+data.item.id

$("#my-jobs-link").on 'click', ->
  $('#my-jobs-list').toggleClass "active"

$("#search-input").keyup ->
  $('#my-jobs-list').removeClass "active"

$("#search-input").on 'click', ->
  $('#my-jobs-list').toggleClass "active"

$('[data-toggle="headline-tab"]').click (e) ->
  $this = $(this)
  loadurl = $this.attr('href')
  targ = $this.attr('data-target')
  if typeof $this.attr('data-loaded') == 'undefined'
    $.get loadurl, (data) ->
      $(targ).html data
      return
  $this.tab 'show'
  $this.attr('data-loaded', true)
  false
