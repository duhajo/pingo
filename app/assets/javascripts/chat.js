/**
 * Chat logic
 *
 * Most of the js functionality is inspired from anatgarg.com
 * jQuery tag Module from the tutorial
 * http://anantgarg.com/2009/05/13/gmail-facebook-style-jquery-chat/
 *
 */


var chatboxFocus = [];
var chatBoxes = [];
var chatBox;

/**
 * ready to chat?
 */
var ready = function () {
  $("#conversation-list .conversation-link").click(function () {
    var convLink = $(this),
      chatbox = $("#chatbox_" + convLink.data('conversation'));
    if (chatbox.size() === 0) {
      $("#chat-wrapper").append('<div id="chatbox_' + convLink.data("conversation") + '" class="pin-chat"></div>');
      $.get(convLink.data("pin_id") + "/conversations/" + convLink.data("conversation"), function (data) {
        $("#chatbox_" + convLink.data('conversation')).html(data);
      }, "html");
    }
    chatbox.show();
    $("#conversation-list").hide();
  });

  chatBox = {

    show_conversations: function () {
      $("#conversation-list").show();
      $(".pin-chat").hide();
    },


    /**
     * creates an inline chatbox on the page by calling the
     * createChatBox function passing along the unique conversation_id
     *
     * @param conversation_id
     */

    chatWith: function (conversation_id) {
      chatBox.createChatBox(conversation_id);
      $("#chatbox_" + conversation_id + " .chat-textarea").focus();
    },

    chatWithPin: function (conversation_id, pin_id) {
      chatBox.createpinChatWrapper(conversation_id, pin_id);
      $("#chatbox_" + conversation_id + " .chat-textarea").focus();
    },

    /**
     * closes the chatbox by essentially hiding it from the page
     *
     * @param conversation_id
     */

    close: function (conversation_id) {
      $('#chatbox_' + conversation_id).css('display', 'none');
      chatBox.restructure();
    },

    /**
     * Plays a notification sound when a new chat message arrives
     */

    notify: function () {
      var audioplayer = $('#chatAudio')[0];
      audioplayer.play();
    },

    /**
     * Handles 'smart layouts' of the chatboxes. Like when new chatboxes are
     * added or removed from the view, it restructures them so that they appear
     * neatly aligned on the page
     */

    restructure: function () {
      var i, chatBoxes, chatbox_id, width;
      for (i = 0; i < chatBoxes.length; i += 1) {
        chatbox_id = chatBoxes[i];
        if ($("#chatbox_" + chatbox_id).css('display') !== 'none') {
          if (i === 0) {
            $("#chatbox_" + chatbox_id).css('right', '20px');
          } else {
            width = (i) * (280 + 7) + 20;
            $("#chatbox_" + chatbox_id).css('right', width + 'px');
          }
        }
      }
    },

    createPinChatWrapper: function (conversation_id, pin_id) {
      $("#chatbox_" + conversation_id + " .chat-textarea").focus();

      $("#chat-messages").append('<div id="chatbox_' + conversation_id + '" class="pin-chat"></div>');

      $.get(pin_id + "/conversations/" + conversation_id, function (data) {
        $('#chatbox_' + conversation_id).html(data);
      }, "html");

      chatBoxes.push(conversation_id);

      chatboxFocus[conversation_id] = false;

      $("#chatbox_" + conversation_id + " .chat-textarea").blur(function () {
        chatboxFocus[conversation_id] = false;
        $("#chatbox_" + conversation_id + " .chat-textarea").removeClass('chat-textareaselected');
      }).focus(function () {
        chatboxFocus[conversation_id] = true;
        $('#chatbox_' + conversation_id + ' .chatboxhead').removeClass('chatboxblink');
        $("#chatbox_" + conversation_id + " .chat-textarea").addClass('chat-textareaselected');
      });

      $("#chatbox_" + conversation_id).click(function () {
        if ($('#chatbox_' + conversation_id + ' .chat-content').css('display') !== 'none') {
          $("#chatbox_" + conversation_id + " .chat-textarea").focus();
        }
      });

      $("#chatbox_" + conversation_id).show();

    },

    /**
     * Takes in two parameters. It is responsible for fetching the specific conversation's
     * html page and appending it to the body of our home page e.g if conversation_id = 1
     *
     * $.get("conversations/1, function(data){
     *    // rest of the logic here
     * }, "html")
     *
     * @param conversation_id
     * @param minimizeChatBox
     */

    createChatBox: function (conversation_id, minimizeChatBox) {
      var chatBoxeslength = 0, i, j, width, minimizedChatBoxes, minimize;

      if ($("#chatbox_" + conversation_id).length > 0) {
        if ($("#chatbox_" + conversation_id).css('display') === 'none') {
          $("#chatbox_" + conversation_id).css('display', 'block');
          chatBox.restructure();
        }
        $("#chatbox_" + conversation_id + " .chat-textarea").focus();
        return;
      }

      $("body").append('<div id="chatbox_' + conversation_id + '" class="chatbox"></div>');

      $.get("/conversations/" + conversation_id, function (data) {
        $('#chatbox_' + conversation_id).html(data);
        $("#chatbox_" + conversation_id + " .chat-content").scrollTop($("#chatbox_" + conversation_id + " .chat-content")[0].scrollHeight);
      }, "html");

      $("#chatbox_" + conversation_id).css('bottom', '0px');

      for (i = 0; i < chatBoxes.length; i += 1) {
        if ($("#chatbox_" + chatBoxes[i]).css('display') !== 'none') {
          chatBoxeslength += 1;
        }
      }

      if (chatBoxeslength === 0) {
        $("#chatbox_" + conversation_id).css('right', '20px');
      } else {
        width = (chatBoxeslength) * (280 + 7) + 20;
        $("#chatbox_" + conversation_id).css('right', width + 'px');
      }

      chatBoxes.push(conversation_id);

      if (minimizeChatBox === 1) {
        minimizedChatBoxes = [];

        if ($.cookie('chatbox_minimized')) {
          minimizedChatBoxes = $.cookie('chatbox_minimized').split(/\|/);
        }
        minimize = 0;
        for (j = 0; j < minimizedChatBoxes.length; j += 1) {
          if (minimizedChatBoxes[j] === conversation_id) {
            minimize = 1;
          }
        }

        if (minimize === 1) {
          $('#chatbox_' + conversation_id + ' .chat-content').css('display', 'none');
          $('#chatbox_' + conversation_id + ' .chat-input').css('display', 'none');
        }
      }

      chatboxFocus[conversation_id] = false;

      $("#chatbox_" + conversation_id + " .chat-textarea").blur(function () {
        chatboxFocus[conversation_id] = false;
        $("#chatbox_" + conversation_id + " .chat-textarea").removeClass('chat-textareaselected');
      }).focus(function () {
        chatboxFocus[conversation_id] = true;
        $('#chatbox_' + conversation_id + ' .chatboxhead').removeClass('chatboxblink');
        $("#chatbox_" + conversation_id + " .chat-textarea").addClass('chat-textareaselected');
      });

      $("#chatbox_" + conversation_id).click(function () {
        if ($('#chatbox_' + conversation_id + ' .chat-content').css('display') !== 'none') {
          $("#chatbox_" + conversation_id + " .chat-textarea").focus();
        }
      });

      $("#chatbox_" + conversation_id).show();
    },

    /**
     * Responsible for listening to the keypresses when chatting. If the Enter button is pressed,
     * we submit our conversation form to our rails app
     *
     * @param event
     * @param chatboxtextarea
     * @param conversation_id
     */

    checkInputKey: function (is_click, event, chatboxtextarea, conversation_id) {
      var message, adjustedHeight, maxHeight;
      if (is_click || (event.keyCode === 13 && event.shiftKey === 0)) {
        event.preventDefault();

        message = chatboxtextarea.val();
        message = message.replace(/^\s+|\s+$/g, "");

        if (message !== '') {
          $('#conversation-form-' + conversation_id).submit();
          $(chatboxtextarea).val('');
          $(chatboxtextarea).focus();
          $(chatboxtextarea).css('height', '44px');
        }
      }

      adjustedHeight = chatboxtextarea.clientHeight;
      maxHeight = 94;

      if (maxHeight > adjustedHeight) {
        adjustedHeight = Math.max(chatboxtextarea.scrollHeight, adjustedHeight);
        if (maxHeight) {
          adjustedHeight = Math.min(maxHeight, adjustedHeight);
        }
        if (adjustedHeight > chatboxtextarea.clientHeight) {
          $(chatboxtextarea).css('height', adjustedHeight + 8 + 'px');
        }
      } else {
        $(chatboxtextarea).css('overflow', 'auto');
      }

    },

    /**
     * Responsible for handling minimize and maximize of the chatbox
     *
     * @param conversation_id
     */

    toggleChatBoxGrowth: function (conversation_id) {
      var minimizedChatBoxes = [], newCookie, i = 0;
      if ($('#chatbox_' + conversation_id + ' .chat-content').css('display') === 'none') {
        if ($.cookie('chatbox_minimized')) {
          minimizedChatBoxes = $.cookie('chatbox_minimized').split(/\|/);
        }

        newCookie = '';

        for (i; i < minimizedChatBoxes.length; i += 1) {
          if (minimizedChatBoxes[i] !== conversation_id) {
            newCookie += conversation_id + '|';
          }
        }

        newCookie = newCookie.slice(0, -1);

        $.cookie('chatbox_minimized', newCookie);
        $('#chatbox_' + conversation_id + ' .chat-content').css('display', 'block');
        $('#chatbox_' + conversation_id + ' .chat-input').css('display', 'block');
        $("#chatbox_" + conversation_id + " .chat-content").scrollTop($("#chatbox_" + conversation_id + " .chat-content")[0].scrollHeight);
      } else {

        newCookie = conversation_id;

        if ($.cookie('chatbox_minimized')) {
          newCookie += '|' + $.cookie('chatbox_minimized');
        }


        $.cookie('chatbox_minimized', newCookie);
        $('#chatbox_' + conversation_id + ' .chat-content').css('display', 'none');
        $('#chatbox_' + conversation_id + ' .chat-input').css('display', 'none');
      }
    }
  };


  /**
   * Cookie plugin
   *
   * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
   * Dual licensed under the MIT and GPL licenses:
   * http://www.opensource.org/licenses/mit-license.php
   * http://www.gnu.org/licenses/gpl.html
   *
   */

  jQuery.cookie = function (name, value, options) {
    var expires = '', date,
      path, domain, secure,
      cookieValue = null,
      cookies, cookie, i = 0;
    if (typeof value !== 'undefined') { // name and value given, set cookie
      options = options || {};
      if (value === null) {
        value = '';
        options.expires = -1;
      }
      if (options.expires && (typeof options.expires === 'number' || options.expires.toUTCString)) {
        if (typeof options.expires === 'number') {
          date = new Date();
          date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
        } else {
          date = options.expires;
        }
        expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
      }
      // CAUTION: Needed to parenthesize options.path and options.domain
      // in the following expressions, otherwise they evaluate to undefined
      // in the packed version for some reason...
      path = options.path ? '; path=' + (options.path) : '';
      domain = options.domain ? '; domain=' + (options.domain) : '';
      secure = options.secure ? '; secure' : '';
      document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
      if (document.cookie && document.cookie !== '') {
        cookies = document.cookie.split(';');
        for (i; i < cookies.length; i += 1) {
          cookie = jQuery.trim(cookies[i]);
          // Does this cookie string begin with the name we want?
          if (cookie.substring(0, name.length + 1) === (name + '=')) {
            cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
            break;
          }
        }
      }
      return cookieValue;
    }
  };
};

$(document).ready(ready);
$(document).on("page:load", ready);
