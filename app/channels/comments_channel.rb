class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments-Question-#{data['question_id']}"
  end
end