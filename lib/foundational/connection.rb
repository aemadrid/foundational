require 'fdb'

module Foundational

  class Connection

    def self.db(api_version = 21)
      unless @db
        FDB.api_version api_version
        @db = FDB.open
      end
      @db
    end

  end

end
