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

  context "dumping methods" do
    let(:file_path) { "/tmp/dummy.sql" }
    before(:each) do
      @dumper = MysqlDumper.new @config
      @dumper.stub(:system)
    end
    describe "#dump_schema_to(destination_file[, options])" do
      it "dump schema to destination_file" do
        executed = false
        @dumper.stub(:system) do |command|
          sql = <<-SQL
          mysqldump -u #{username} -p#{password} -R -d --skip-comments #{database} > #{file_path}
          SQL
          command.should == sql.strip
          executed = true
        end

        @dumper.dump_schema_to(file_path)   
        executed.should be_true
      end

      it "preserves tables data if specified" do
        table1 = "table1"
        table2 = "table2"
        sql_schema_only = 
          "mysqldump -u #{username} -p#{password} -R -d --skip-comments #{database} > #{file_path}"
        sql_with_tables =
          "mysqldump -u #{username} -p#{password} --skip-comments #{database} #{table1} #{table2} >> #{file_path}"

        @dumper.should_receive(:system).with(sql_schema_only)
        @dumper.should_receive(:system).with(sql_with_tables)

        @dumper.dump_schema_to(file_path, { :preserve => [ table1, table2 ] })   
      end
    end

    describe "#dump_to(destination_file)" do
      it "dumps whole db to destination_file" do
        @dumper.should_receive(:system).
          with("mysqldump -u #{username} -p#{password} -R --skip-comments #{database} > #{file_path}")
        @dumper.dump_to(file_path)
      end
    end

    describe "#load_from(sql_file)" do
      it "loads sql_file to specific db" do
        @dumper.should_receive(:system).
          with("cat #{file_path} | mysql -u #{username} -p#{password} #{database}")    
        @dumper.load_from(file_path)
      end
    end
    
  end



end
