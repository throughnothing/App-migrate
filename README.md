App-migrate
===========

Easily migrate your database.

#Set up

`migrate install`

The setup process creates a very simple table in your database to maintain
records of the migrations. The table looks as below:

`CREATE TABLE db_migrate_tiny (version INT PRIMARY KEY)`

#Migrate to latest migration

`migrate latest`

##Mgrate to a specific version

`migrate to VERSION`

#Generate new migration

`migrate generate NAME`

By default, migrations are generated in `migrations` directory. You can also
pass `--dir` option to specify a directory.

# Testing

To run the tests you must set the following environment variables:

* `PG_HOST` - the postgres host to connect to (defaults to `127.0.0.1`)
* `PG_USER` - the postgres user to connect with
* `PG_PWD`  - the password for the postgres user being connected with

The postgres test user must have `CREATEDB` permissions to create temporary
databases for running tests in.  You can give a user/role this permission
by running:

```
ALTER ROLE user_name WITH CREATEDB;
```
