# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ready = ->

  ###*
  # When the send message link on our home page is clicked
  # send an ajax request to our rails app with the sender_id and
  # recipient_id
  ###

  $('.start-conversation').click (e) ->
    e.preventDefault()
    sender_id = $(this).data('sid')
    recipient_id = $(this).data('rip')
    $.post '/conversations', {
      sender_id: sender_id
      recipient_id: recipient_id
    }, (data) ->
      chatBox.chatWith data.conversation_id
      return
    return

  ###*
  # Used to minimize the chatbox
  ###

  $(document).on 'click', '.toggleChatBox', (e) ->
    e.preventDefault()
    id = $(this).data('cid')
    chatBox.toggleChatBoxGrowth id
    return

  ###*
  # Used to close the chatbox
  ###

  $(document).on 'click', '.closeChat', (e) ->
    e.preventDefault()
    id = $(this).data('cid')
    chatBox.close id
    return

  ###*
  # Listen on keypress' in our chat textarea and call the
  # chatInputKey in chat.js for inspection
  ###

  $(document).on 'keydown', '.chatboxtextarea', (event) ->
    id = $(this).data('cid')
    chatBox.checkInputKey event, $(this), id
    return

  ###*
  # When a conversation link is clicked show up the respective
  # conversation chatbox
  ###

  $('a.conversation').click (e) ->
    e.preventDefault()
    conversation_id = $(this).data('cid')
    chatBox.chatWith conversation_id
    return
  return

$(document).ready ready
$(document).on 'page:load', ready