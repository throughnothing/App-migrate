use Test::More;
use File::Slurp qw( read_file );

use t::lib::Common qw( dbh migrate );


# Try to migrate out of order where order matters
my $reval = migrate 'apply', 2;
ok $reval != 1, 'Applying 2 first failed';

# Add table test1
$reval = migrate( 'apply', '1' );
is $reval => 0, 'apply 1 succeeded';
my $res = dbh->selectall_arrayref('SELECT * FROM migrations');
is @$res => 1, '1 migration added to migrations table';

# Add column test2 to table test1
$reval = migrate( 'apply', '2' );
is $reval => 0, 'apply 2 succeeded';
$res = dbh->selectall_arrayref('SELECT * FROM migrations');
is @$res => 2, '2 migrations in migrations table';

# Unapply 2
$reval = migrate( 'unapply', '2' );
is $reval => 0, 'unapply 2 succeeded';
my $res = dbh->selectall_arrayref('SELECT * FROM migrations');
is @$res => 1, '1 migration removed from migrations table';

# Unapply 1
$reval = migrate( 'unapply', '1' );
is $reval => 0, 'unapply 1 succeeded';
my $res = dbh->selectall_arrayref('SELECT * FROM migrations');
is @$res => 0, '0 migrations left in migrations table';

done_testing;
