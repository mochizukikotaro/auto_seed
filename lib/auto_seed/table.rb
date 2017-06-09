class AutoSeed::Table

  require_relative './params'

  @@sowed_table_names = []

  attr_reader :name, :model

  # @param [String] table name
  # NOTE: 小文字大文字をここでいったん吸収する....
  def initialize(table_name)
    @name = table_name.classify.constantize.table_name
    @model = @name.classify.constantize
  end

  # 種をまく人
  def sow
    if parents.blank?
      sow_without_parent
    else
      parents.each do |parent|
        next if @@sowed_table_names.include?(parent.name)
        parent.sow
      end
      sow_with_parent
    end
  end


  # @return [Array<String>] parent table
  def parents
    model = @name.classify.constantize
    parent_names = model.reflect_on_all_associations(:belongs_to)
    .map(&:name).map(&:to_s)
    tables = []
    parent_names.each do |name|
      tables << AutoSeed::Table.new(name)
    end
    tables
  end

  private

  def sow_with_parent
    1.upto(2) do |i|
      params = AutoSeed::Params.new(self).generate
      @model.create(params)
    end
    @@sowed_table_names << @name
  end

  def sow_without_parent
    1.upto(2) do |i|
      params = AutoSeed::Params.new(self).generate
      @model.create(params)
    end
    @@sowed_table_names << @name
  end

end
