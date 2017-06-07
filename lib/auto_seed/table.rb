class AutoSeed::Table

  require_relative './params'

  attr_reader :name, :model

  # @param [String] table name
  # NOTE: 小文字大文字をここでいったん吸収する....
  def initialize(table_name)
    @name = table_name.classify.constantize.table_name
    @model = @name.classify.constantize
  end

  # 種をまく人
  def sow
    if parent
      parent.sow
      sow_with_parent
    else
      sow_without_parent
    end
  end


  # @return [String] parent table
  # @return [Nil]
  def parent
    model = @name.classify.constantize
    parent_name = model.reflect_on_all_associations(:belongs_to)
                        .map(&:name).first.to_s
    return nil if parent_name.blank?
    AutoSeed::Table.new(parent_name)
  end

  # table names of parents & self
  # @return [Array<String>]
  def target_names
    @target_names = []
    insert_name(self)
    @target_names
  end


  private

  def insert_name(table)
    @target_names << table.name
    if table.parent
      insert_name(table.parent)
    end
  end

  def sow_with_parent
    parent.model.all.each do |parent_obj|
      1.upto(2) do |i|
        params = AutoSeed::Params.new(self.name).generate

        # NOTE: 以下のような生成方法にすることで、
        # foreign_key の値にランダム値が入っていても気にしない
        parent_obj.send(self.name).create(params)
      end
    end
  end

  def sow_without_parent
    1.upto(2) do |i|
      params = AutoSeed::Params.new(self.name).generate
      @model.create(params)
    end
  end


end
