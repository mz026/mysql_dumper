require "mysql_dumper"

describe MysqlDumper do
  let(:database) { "db_name" }
  let(:username) { "the_username" }
  let(:password) { "the_pwd" }
  before(:each) do
    @config = {
      "database" => database,
      "username" => username,
      "password" => password
    }
  end

  it "takes a config to init" do
    dumper = MysqlDumper.new @config
  end

  def self.ensure_in_config attr_name
    it "raises MysqlDumper::InitFailedException if no #{attr_name}" do
      @config.delete attr_name

      expect {
        MysqlDumper.new @config
      }.to raise_error(MysqlDumper::InitFailedException, 
                       "#{attr_name} is required to init a dumper")
    end
  end

  ensure_in_config "username"
  ensure_in_config "password"
  ensure_in_config "database"

  describe "#dump_schema_to(destination_file[, options])" do
    let(:file_path) { "/tmp/dummy.sql" }
    before(:each) do
      @dumper = MysqlDumper.new @config
      @dumper.stub(:system)
    end

    it "dump to destination_file" do
      executed = false
      @dumper.stub(:system) do |command|
        sql = <<-SQL
        mysqldump -u #{username} -p#{password} -R -d #{database} > #{file_path}
        SQL
        command.should == sql.strip
        executed = true
      end

      @dumper.dump_schema_to(file_path)   
      executed.should be_true
    end
  end

end
