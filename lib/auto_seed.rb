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

      table_names.each do |name|
        table = AutoSeed::Table.new(name)
        table.sow
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
