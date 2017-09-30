class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments-#{data['commentable_type']}-#{data['commentable_id']}"
  end
end