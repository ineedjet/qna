# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  if gon.page == 'question'
    App.cable.subscriptions.create({
      channel: 'AnswersChannel'
    },{
      connected: ->
        @perform 'follow', question_id: gon.question.id
      ,

      received: (data) ->
        answer = JSON.parse(data)
        if !gon.current_user || (answer.user_id != gon.current_user.id)
          $('.answers').append( JST['templates/answer']({ answer: answer }) )

          $(".vote").bind 'ajax:success', (e, data, status, xhr) ->
            votable = $.parseJSON(xhr.responseText)
            $(this).parent().find(".vote_raiting").html("rating: " + votable.vote_rating)
            $(this).parent().find(".vote").hide()
            $(this).parent().find(".vote_delete").show()
          $(".vote_delete").bind 'ajax:success', (e, data, status, xhr) ->
            votable = $.parseJSON(xhr.responseText)
            $(this).parent().find(".vote_raiting").html("rating: " + votable.vote_rating)
            $(this).parent().find(".vote").show()
            $(this).parent().find(".vote_delete").hide()
    })