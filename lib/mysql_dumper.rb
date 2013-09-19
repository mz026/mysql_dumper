require "mysql_dumper/version"

class MysqlDumper
  def initialize config
    @password = config["password"]
    @username = config["username"]
    @database = config["database"]
    raise InitFailedException, "password is required to init a dumper" unless @password
    raise InitFailedException, "username is required to init a dumper" unless @username
    raise InitFailedException, "database is required to init a dumper" unless @database
  end

  def dump_schema_to path, options = {}
    system "mysqldump -u #{@username} -p#{@password} -R -d --skip-comments #{@database} > #{path}"
  end

    

  class InitFailedException < Exception; end;
end
