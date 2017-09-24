$ ->
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