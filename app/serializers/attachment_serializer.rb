class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url, :created_at, :updated_at

  def filename
    object.file.file.filename
  end

  def url
    object.file.url
  end

end
