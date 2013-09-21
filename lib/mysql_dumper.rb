require "mysql_dumper/version"

class MysqlDumper
  class InitFailedException < Exception; end;
  def initialize config
    @password = config["password"]
    @username = config["username"]
    @database = config["database"]
    raise InitFailedException, "username is required to init a dumper" unless @username
    raise InitFailedException, "database is required to init a dumper" unless @database
  end

  def dump_schema_to path, options = {}
    preserved_tables = options[:preserve] || []
    table_string = preserved_tables.join(" ")

    system "mysqldump -u #{@username} -p#{@password} -R -d --skip-comments #{@database} | sed 's/ AUTO_INCREMENT=[0-9]*\\b//' > #{path}"
    if ! table_string.strip.empty?
      system "mysqldump -u #{@username} -p#{@password} --skip-comments #{@database} #{table_string} >> #{path}"
    end
  end

  def dump_to path
    system "mysqldump -u #{@username} -p#{@password} -R --skip-comments #{@database} > #{path}"
  end

  def load_from path
    system "cat #{path} | mysql -u #{@username} -p#{@password} #{@database}"
  end

end
