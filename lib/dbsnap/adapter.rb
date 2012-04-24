module DBSnap::Adapter
  # == Constants ============================================================

  # == Submodules ===========================================================

  autoload(:Abstract, 'dbsnap/adapter/abstract')
  autoload(:MySQL, 'dbsnap/adapter/mysql')
  # autoload(:Postgres, 'dbsnap/adapter/postgres')

  # == Module Methods =======================================================
  
  def self.for_config(config)
    case (config.adapter)
    when 'mysql'
      DBSnap::Adapter::MySQL.new(config)
    when 'mysql2'
      # ...
    else
      raise DBSnap::RuntimeError, "Unknown adapter type #{@adapter}"
    end
  end
end
