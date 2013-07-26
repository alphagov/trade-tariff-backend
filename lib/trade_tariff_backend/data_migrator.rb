require 'singleton'
require 'forwardable'

module TradeTariffBackend
  class DataMigrator
    autoload :ConsoleReporter, 'trade_Tariff_backend/data_migrator/console_reporter'
    autoload :NullReporter,    'trade_Tariff_backend/data_migrator/null_reporter'

    MIGRATION_FILE_PATTERN = /\A(\d+)_.+\.rb\z/i.freeze

    include Singleton
    extend SingleForwardable

    def_delegators :instance, :migrations, :migrations=,
                              :migrate, :migration, :rollback,
                              :status, :reporter=

    attr_writer :migrations
    attr_writer :reporter

    def self.load_migration_files
      migration_files.each { |file| load file }
    end

    # Define a new migration
    def migration(&block)
      @migrations ||= []

      TradeTariffBackend::DataMigration.new(&block).tap { |migration|
        @migrations << migration
      }
    end

    def report_with
      @reporter || NullReporter
    end

    # List of available migrations
    def migrations
      @migrations || []
    end

    # Migrates all pending migrations
    def migrate
      migrations.select(&:can_rollup?).each { |migration|
        migration.up.apply

        report_with.applied(migration)
      }
    end

    # Rollsback last applied migration
    def rollback
      migrations.select(&:can_rolldown?).last.tap { |migration|
        migration.down.apply

        report_with.rollback(migration)
      }
    end

    # Display data migration status
    def status
      migrations.each { |migration|
        report_with.status(migration)
      }
    end

    private

    def self.migration_files
      files, directory = [], TradeTariffBackend.data_migration_path

      Dir.new(directory).each do |file|
        next unless MIGRATION_FILE_PATTERN.match(file)
        files << File.join(directory, file)
      end

      files.sort_by { |f|
        MIGRATION_FILE_PATTERN.match(File.basename(f))[1].to_i
      }
    end
  end
end

TradeTariffBackend::DataMigrator.load_migration_files