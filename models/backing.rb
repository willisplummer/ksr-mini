module Models
  class Backing
    TABLE = :backings

    attr_accessor :project, :cc, :amount

    def save(db)
      db.add(TABLE, self)
    end
  end
end
