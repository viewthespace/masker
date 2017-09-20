class Masker
  module Configurations
    class Postgres
      attr_reader :tables

      def initialize(conn, config_path, logger, opts = {})
        @config = Configuration.load(config_path)
        @conn = conn
        @logger = logger
        @opts = opts
        @tables = config['mask']
      end

      def ids_to_mask
        @ids_to_mask ||=
          tables.keys.each_with_object(Hash.new { |k, v| k[v] = [] }) do |table, ids|
            conn.exec("SELECT id FROM #{table};") do |result|
              ids[table].concat(result.values.flatten - Array(opts.dig(:safe_ids, table.to_sym)).map(&:to_s))
            end
          end
      end

      def missing_tables
        tables.keys.each_with_object([]) do |table_name, missing_tables|
          conn.exec("SELECT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = '#{table_name}');") do |result|
            if result[0]['exists'] == 'f'
              missing_tables << table_name
              logger.warn "Table: #{table_name} exists in configuration but not in database."
            end
          end
        end
      end

      def missing_columns
        tables.each_with_object(Hash.new { |h, k| h[k] = [] }) do |(table_name, columns), missing_columns|
          columns.keys.each do |column_name|
            sql = <<~SQL
              SELECT EXISTS (
                SELECT 1 FROM information_schema.columns
                WHERE table_name='#{table_name}'
                AND column_name='#{column_name}'
              );
            SQL
            conn.exec(sql) do |result|
              if result[0]['exists'] == 'f'
                missing_columns[table_name] << column_name
                logger.warn "Column: #{table_name}:#{column_name} exists in configuration but not in database."
              end
            end
          end
        end
      end

      def remove_missing_tables
        missing_tables.each do |table|
          tables.delete(table)
        end
      end

      def remove_missing_columns
        missing_columns.each do |table, columns|
          columns.each do |column|
            tables[table].delete(column)
          end
        end
      end

      def tables_to_truncate
        config['truncate']
      end

      private

      attr_reader :config, :opts, :conn, :logger
    end
  end
end
