# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if gon.question

    App.cable.subscriptions.create({
      channel: 'CommentsChannel'
    },{
      connected: ->
        @perform 'follow', question: gon.question.id
      ,

      received: (data) ->
        comment = JSON.parse(data)
        if !gon.current_user || (comment.user_id != gon.current_user.id)
          $("##{comment.commentable_type}-#{comment.commentable_id} .comments").append( JST['templates/comment']({ comment: comment }) )
    })