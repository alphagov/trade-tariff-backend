class ChapterNote < Sequel::Model
  plugin :json_serializer
  plugin :active_model

  many_to_one :chapter, dataset: -> {
    Chapter.where(goods_nomenclature_item_id: chapter_goods_id)
  }

  def validate
    super

    errors.add(:content, 'cannot be empty') if !content || content.empty?
    errors.add(:chapter_id, 'cannot be empty') if chapter_id.blank?
  end

  def chapter_goods_id
    chapter_id.ljust('0', 10)
  end
end
