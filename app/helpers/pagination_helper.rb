module PaginationHelper
  def start_index_of(collection)
    (collection.current_page - 1) * collection.limit_value + 1
  end
end
