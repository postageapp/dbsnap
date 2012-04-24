class DBSnap::Adapter::MySQL < DBSnap::Adapter::Abstract
  # == Constants ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def connect(use = true)
    require 'mysql'
    
    @connection = ::Mysql.new(
      @config.host,
      @config.username,
      @config.password,
      use ? @config.database : '',
      @config.port,
      @config.socket
    )
  end
  
  def tables
    result = [ ]
    
    @connection.query("SHOW TABLE STATUS").each do |row|
      # Name                          | Engine | Version | Row_format | Rows   | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation       | Checksum | Create_options | Comment
      # puts row.inspect

      result << row[0]
    end
    
    result
  end
  
  def export_table!(table, path = nil)
    path ||= File.expand_path("#{table}.dump", @config.snapshot_path)
    
    @connection.query(%Q[
      SELECT * FROM `#{table}` INTO OUTFILE '#{@connection.escape_string(path)}'
    ])
  end
end
