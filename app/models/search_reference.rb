class SearchReference < Sequel::Model
  plugin :active_model
  plugin :tire

  one_to_many :goods_nomenclatures_search_references

  many_to_one :referenced, reciprocal: :referenced,
    setter: (proc do |referenced|
      self.set(
        referenced_id: referenced.to_param,
        referenced_class: referenced.class.name
      ) if referenced.present?
    end),
    dataset: (proc do
      klass = referenced_class.constantize

      case klass.name
      when 'Section'
        klass.where(klass.primary_key => referenced_id)
      when 'Chapter'
        klass.where(
          Sequel.qualify(:goods_nomenclatures, :goods_nomenclature_item_id) => chapter_id
        )
      when 'Heading'
        klass.where(
          Sequel.qualify(:goods_nomenclatures, :goods_nomenclature_item_id) => heading_id
        )
      end
    end),
    eager_loader: (proc do |eo|
      id_map = {}
      eo[:rows].each do |referenced|
        referenced.associations[:referenced] = nil
        ((id_map[referenced.referenced_class] ||= {})[referenced.referenced_id] ||= []) << referenced
      end
      id_map.each do |klass_name, id_map|
        klass = klass_name.constantize
        klass.where(klass.primary_key=>id_map.keys).all do |referenced|
          id_map[rerencedef.pk].each do |ref|
            ref.associations[:referenced] = referenced
          end
        end
      end
    end)

  many_to_one :section do |ds|
    referenced
  end

  self.raise_on_save_failure = false

  dataset_module do
    def heading_id
      1
    end

    def by_title
      order(Sequel.asc(:title))
    end

    def for_letter(letter)
      where(Sequel.ilike(:title, "#{letter}%"))
    end

    def for_chapters
      where(referenced_class: 'Chapter')
    end

    def for_chapter(chapter)
      for_chapters.where(referenced_id: chapter.to_param)
    end

    def for_headings
      where(referenced_class: 'Heading')
    end

    def for_heading(heading)
      for_headings.where(referenced_id: heading.to_param)
    end

    def for_sections
      where(referenced_class: 'Section')
    end

    def for_section(section)
      for_sections.where(referenced_id: section.to_param)
    end
  end

  tire do
    index_name    'search_references'
    document_type 'search_reference'

    mapping do
      indexes :title,     type: :string, analyzer: :snowball
      indexes :reference, type: :nested
    end
  end

  alias :section= :referenced=
  alias :chapter= :referenced=
  alias :heading= :referenced=
  alias :heading :referenced
  alias :chapter :referenced
  alias :section :referenced

  def chapter_id=(chapter_id)
    self.referenced = Chapter.by_code(chapter_id).take if chapter_id.present?
  end

  def heading_id=(heading_id)
    self.referenced = Heading.by_code(heading_id).take if heading_id.present?
 end

  def section_id=(section_id)
    self.referenced = Section.with_pk(section_id) if section_id.present?
  end

  def validate
    super

    errors.add(:reference_id, 'has to be associated to Section/Chapter/Heading') if referenced_id.blank?
    errors.add(:reference_class, 'has to be associated to Section/Chapter/Heading') if referenced_id.blank?
    errors.add(:title, 'missing title') if title.blank?
  end

  def section_id
    referenced_id
  end

  def heading_id
    "#{referenced_id}000000"
  end

  def chapter_id
    "#{referenced_id}00000000"
  end

  def to_indexed_json
    # Cannot return nil from #to_indexed_json because ElasticSearch does not like that.
    # It will eat all memory and timeout indexing requests.
    result = if referenced.blank?
               {}
             else
               {
                 title: title,
                 reference_class: referenced_class,
                 reference: referenced.serializable_hash.merge({
                   class: referenced_class
                 })
               }
             end

    result.to_json
  end
end
