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