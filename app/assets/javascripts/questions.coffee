# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected!'
      @perform 'follow'
    ,

    received: (data) ->
      new_question = $.parseJSON(data)
      if !gon.current_user || (gon.current_user.id != new_question.user.id)
        if gon.page == 'questions_index'
          $('.questions-list').append(JST['templates/question']({
            question: new_question
          }))

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
