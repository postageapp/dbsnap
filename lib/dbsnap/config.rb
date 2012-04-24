class DBSnap::Config
  # == Constants ===========================================================
  
  ENVIRONMENT_DEFAULT = 'development'.freeze
  ENVIRONMENT_VARS = %w[
    RAILS_ENV
    RACK_ENV
    DAEMON_ENV
  ].freeze
  
  DEFAULT_CONFIG = {
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :snapshot_path => '/tmp'
  }

  # == Properties ===========================================================
  
  attr_accessor :environment
  attr_accessor :adapter
  attr_accessor :database
  attr_accessor :username
  attr_accessor :password
  attr_accessor :host
  attr_accessor :port
  attr_accessor :socket
  
  attr_accessor :snapshot_path
  
  # == Class Methods ========================================================
  
  def self.project_config_path
    test_path = File.expand_path('.')

    while (File.exists?(test_path) and test_path.length > 1)
      relative_config_path = "#{test_path}/config/database.yml"

      if (File.exists?(relative_config_path))
        return relative_config_path
      end
      
      new_test_path = File.expand_path('..', test_path)
      
      if (new_test_path == test_path)
        return
      end
      
      test_path = new_test_path
    end
  end
  
  def self.for_project(environment = nil)
    path = self.project_config_path
    
    path and new(environment, path)
  end

  # == Instance Methods =====================================================
  
  def initialize(environment = nil, path = nil)
    assign_attributes(DEFAULT_CONFIG)

    @environment = environment || ENVIRONMENT_VARS.collect do |var|
      ENV[var]
    end.compact.first || ENVIRONMENT_DEFAULT
    
    if (path)
      if (environment_config = read(@environment, path))
        assign_attributes(environment_config)
      else
        # ...?
      end
    end
  end
  
  def read(environment, path)
    require 'yaml'
    
    open(path) do |f|
      config = YAML.load(f)
      
      config and config[environment.to_s]
    end
  end
  
  def to_h
    h = {
      :adapter => @adapter.dup,
      :environment => @environment.dup,
      :username => @username.dup,
      :password => @password.dup
    }
    
    if (@host)
      h[:host] = @host.dup
    end
    
    h
  end

protected
  def assign_attributes(attributes)
    attributes.each do |attribute, value|
      attribute_variable = :"@#{attribute}"

      instance_variable_set(attribute_variable, value)
    end
  end
end
