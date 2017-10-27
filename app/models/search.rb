class Search < ApplicationRecord
  SEARCHABLE_ENTITIES = %w(Question Answer User Comment)

  def self.find(q, search_in='All')
    (search_in.in?(SEARCHABLE_ENTITIES) ? search_in.classify.constantize : ThinkingSphinx )
        .search(q)
  end
end
