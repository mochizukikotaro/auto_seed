class AutoSeed::Params

  def initialize(table_name)
    @table_name = table_name
    @columns = columns
  end

  # @return [Hash] attributes
  def generate
    params_from_columns
  end

  private

  def columns
    all_columns = @table_name.classify.constantize.columns
    # NOTE: 参照渡しなので、reject! とかすると小一時間ハマれます
    cols = all_columns.reject do |c|
      %(id created_at updated_at).include? c.name
    end
    cols
  end

  def params_from_columns
    params = {}
    @columns.each do |column|
      params[column.name] = sample_value(column.sql_type)
    end
    params
  end

  def sample_value(sql_type)
    case sql_type
    when /bigint/
      rand(99999999)
    when /varchar/
      'sample_varchar'
    when /datetime/
      DateTime.now
    end
  end


  # NOTE: 使ってないけどメモしておきたい
  # @return [String]
  # @return [Nil]
  def foreign_key
    if @table.parent
      parente_name = @table.parent.name
      @table.model.reflections[parente_name].foreign_key
    else
      nil
    end
  end

end
