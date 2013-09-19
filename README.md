# MysqlDumper

MysqlDumper is a ruby wrapper of `mysqldump`.
It provides both ruby and command line interface.

## Usage

### Ruby interface:

        require 'mysql_dumper'
        config = {
          "database" => "the_db_name",
          "username" => "db_user_name"
          "password" => "xxxx"
        }

        dumper = MysqlDumper.new config

        # dump whole db, including stored procedure
        dumper.dump_to("path/to/db.sql")

        # dump only schema and certain tables
        dumper.dump_schema_to("path/to/db.sql", { :preserve => ["table1", "table2"] })

        # load a sql file to a database
        dumper.load_from("path/to/db.sql")

### command-line interface: (more expressive than native mysqldump interface)

1. dump whole db:
`$ mysql_dumper dump DBNAME --to path/to/db.sql -u USERNAME [-p PASSWORD]`

2. dump schema only:
`$ mysql_dumper dump_schema DBNAME --to path/to/schema.sql -u USERNAME [--perserve table1,table2...] [-p PASSWORD]`

3. load from schema:
`$ mysql_dumper load DBNAME --from path/to/db.sql -u USERNAME [-p PASSWORD]`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
