require "auto_seed/version"

module AutoSeed
  # Your code goes here...

  require_relative './auto_seed/table'

  # def truncate
  #   Article.all.each { |u| u.destroy }
  #   User.all.each { |u| u.destroy }
  #   Company.all.each { |u| u.destroy }
  # end

  class Sower
    def sow_all

      puts "
      ===================
      test start
      ==================="

      sowed_tables = []

      table_names.each do |name|

        # NOTE: 一度種撒かれたものはスキップ
        next if sowed_tables.include?(name)

        table = AutoSeed::Table.new(name)
        table.sow
        sowed_tables += table.target_names
      end
    end

    private

    # @return [Array<String>] table names array
    def table_names
      ActiveRecord::Base.connection
      .tables
      .select{|s| s.classify.constantize rescue false}
    end
  end
end
