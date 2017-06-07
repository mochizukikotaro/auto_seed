class AutoSeed::Params

  def initialize(table)
    @table        = table
    @columns      = columns
    @foreign_keys = foreign_keys
  end

  # @return [Hash] attributes for model
  def generate
    params = {}
    @columns.each do |column|
      if @foreign_keys.include?(column.name)
        params[column.name] = foreign_id(column.name)
      else
        params[column.name] = sample_value(column.sql_type)
      end
    end
    params
  end

  private

  def foreign_id(foreign_key)

  end

  def columns
    all_columns = @table.model.columns
    # NOTE: 参照渡しなので、reject! とかすると小一時間ハマれます
    cols = all_columns.reject do |c|
      %(id created_at updated_at).include? c.name
    end
    cols
  end

  # @return [Array<String>]
  def foreign_keys
    @table.model.reflections.values.map(&:foreign_key)
  end

  # @return [Array]
  # NOTE: 単数か複数のどちらがかえるか分からない..
  def foreign_table_name(key)
    name = @table.model.reflections
              .select{|k,v| v.foreign_key == key}
              .keys.first
  end

  # NOTE: 適当な id を返却したい
  # TODO: ひとまず、先頭の id を適当に返す。
  # 後に分散させる
  def foreign_id(key)
    name = foreign_table_name(key)
    name.classify.constantize.first.id
  end


  def sample_value(sql_type)
    case sql_type
    when /bigint/
      rand(99999999)
    when /varchar/
      'sample_varchar'
    when /datetime/
      DateTime.now
    when /tinyint/
      rand(1)
    when /int/
      rand(9999)
    when /text/
      'sample_text'
    else
      'you should check sql_type'
    end
  end

end
