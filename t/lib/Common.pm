package t::lib::Common;
use Capture::Tiny qw( capture );
use DBI;
use Exporter 'import';
use File::Slurp qw( read_file );


our @EXPORT_OK = qw(
    dbh
    migrate
);

my $PG_HOST = $ENV{PG_HOST} || '127.0.0.1';
my $PG_USER = $ENV{PG_USER} or die "Need PG_USER!";
my $PG_PWD  = $ENV{PG_PWD}  or die "Need PG_PWD!";

my $dsn = "dbi:Pg:dbname=postgres;host=$PG_HOST";
my $dbh_master = DBI->connect( $dsn, $PG_USER, $PG_PWD );

# Create a temporary database
my $new_db = "migrate_test_$$";
$dbh_master->do( "CREATE DATABASE $new_db" );
$dsn = "dbi:Pg:dbname=$new_db;host=$PG_HOST";
my $dbh = DBI->connect( $dsn , $PG_USER, $PG_PWD );

# Setup the migrations table in sqlite
migrate( 'install' );


sub migrate {
    my @args = @_;
    push @args, '-d', $dsn, '-u', 'crowdtilt',
        '-p', '12345', '--dir=t/migrations';
    my $reval;
    capture { $reval = system 'bin/migrate', @args; };
    return $reval;
}

sub dbh { $dbh }

# Clean up temporary Database created
sub END {
    # Disconnect from new temp db
    $dbh->disconnect;
    # Drop temp db from master
    $dbh_master->do("DROP DATABASE $new_db");
}

1;
