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
      $('.questions-list').append data
  })
