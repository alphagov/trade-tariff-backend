require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/chief_file_name_generator'
require "csv"

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    class << self
      def download(date)
        chief_file = ChiefFileNameGenerator.new(date)
        perform_download(chief_file.name, chief_file.url, date)
      end

      def update_type
        :chief
      end
    end

    def import!
      instrument("apply_chief.tariff_synchronizer", filename: filename) do
        ChiefImporter.new(file_path, issue_date).import

        mark_as_applied
      end

      ::ChiefTransformer.instance.invoke(:update, self)
    end

    private

    def self.validate_file!(cvs_string)
      begin
        CSV.parse(cvs_string)
      rescue CSV::MalformedCSVError => e
        raise InvalidContents.new(e.message, e)
      end
    end
  end
end
