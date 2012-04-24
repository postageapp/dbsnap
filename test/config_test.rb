require 'helper'

class ConfigTest < Test::Unit::TestCase
  def config_path(name)
    File.expand_path("config/#{name}.yml", File.dirname(__FILE__))
  end
  
  def test_defaults
    config = DBSnap::Config.new
    
    assert_equal DBSnap::Config::ENVIRONMENT_DEFAULT, config.environment
  end

  def test_force_environment
    config = DBSnap::Config.new('test')
    
    assert_equal 'test', config.environment
  end
  
  def test_project_config_path
    assert_equal config_path('database'), DBSnap::Config.project_config_path
  end

  def test_example_1
    config = DBSnap::Config.new('development', config_path('example_1'))
    
    assert_equal DBSnap::Config::ENVIRONMENT_DEFAULT, config.environment

    assert_equal 'test_database', config.database
    assert_equal 'example', config.username
    assert_equal 'example_password', config.password
    assert_equal '/tmp/mysqld.sock', config.socket
    
    expected_hash = {
      :adapter => "mysql",
      :environment => "development",
      :username => "example",
      :password => "example_password",
      :host => "localhost"
    }
    
    assert_equal expected_hash, config.to_h
  end
end
