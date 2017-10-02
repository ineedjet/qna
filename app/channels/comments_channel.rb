class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments-for-question-#{data['question']}"
  end
end