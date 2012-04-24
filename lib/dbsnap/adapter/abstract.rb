class DBSnap::Adapter::Abstract
  # == Constants ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def initialize(config, auto_connect = true)
    @config = config

    if (auto_connect)
      self.connect
    end
  end
  
  # This method is defined in a subclass to perform the actual connection.
  def connect(use = true)
    # ...
  end
end
