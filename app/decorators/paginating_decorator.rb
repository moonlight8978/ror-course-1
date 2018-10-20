class PaginatingDecorator < Draper::CollectionDecorator
  delegate(
    :current_page, :total_pages, :limit_value, :entry_name,
    :total_count, :offset_value, :last_page?
  )

  def count_from
    (current_page - 1) * limit_value + 1
  end

  def count_to
    count_from - 1 + size
  end
end
