require 'fdb'

module Foundational

  class Connection

    def self.db
      unless @db
        FDB.api_version 21
        @db = FDB.open
      end
      @db
    end

  end

end
