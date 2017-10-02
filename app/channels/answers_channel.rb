class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['question_id']}"
  end
end