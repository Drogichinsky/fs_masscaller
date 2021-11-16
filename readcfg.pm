#!/usr/bin/perl
#read config from losecall_conf
package readcfg;
use DBI;
my $dbh = DBI->connect('dbi:Pg:dbname=freeswitchdb;host=127.0.0.1','postgres','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});

if ($DBI::err != 0) {
  print $DBI::errstr . "\n";
  exit($DBI::err);
}

#$context = "a1.fs.dantser.net";
#$name = "queue_4";

sub readcfg1 {
$name = $_[0];

$load_cfg_query = "select * from losecall_conf where name = '".$name."'";

$query = $load_cfg_query;

$sth = $dbh->prepare($query);
$rv = $sth->execute();
if (!defined $rv) {
  print "При выполнении запроса '$query' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}

while (@arcfg = $sth->fetchrow_array()) {
  foreach $i (@arcfg) {
    #print "$i\t";
  }

our $dst_num = @arcfg[1];
our $free_period = @arcfg[2];
our $time2past = @arcfg[3];
our $note = @arcfg[5];
our $autocall = @arcfg[8];
our $context = @arcfg[10];
our $fail_causes = @arcfg[11];
our $orderlc = @arcfg[12];
our $time_zone = @arcfg[13];
our $sip_to_user = @arcfg[14];


  #print "\n";
};
};

sub readcfg_ac {
$name = $_[0];
$query = "select * from losecall_conf where name = '".$name."';";
$sth = $dbh->prepare($query);
$rv = $sth->execute();
print "\n$query";
@ar = $sth->fetchrow_array();
print "\nResult: @ar\n";
our $dst_num = @ar[1];
$dst_num =~ s/\\047/'/g; # восстанавливаем кавычки
our $free_period = @ar[2];
our $autocall_id = @ar[8];
our $context = @ar[10];
our $orderlc = @ar[12];


$load_cfg_query = "select * from autocall_conf where context = '".$context."' and id = '".$autocall_id."';";

$query = $load_cfg_query;
print "\n$query";
$sth = $dbh->prepare($query);
$rv = $sth->execute();
if (!defined $rv) {
  print "При выполнении запроса '$query' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}

@arcfg = $sth->fetchrow_array();
print "\nResult: @arcfg\n";
our $callback_ext = @arcfg[1];
our $wait_time = @arcfg[2];
our $deltas_after_hours = @arcfg[3];
our $context = @arcfg[12];
our $note = @arcfg[6];
our $trunk = @arcfg[7];
our $free_agents = @arcfg[8];
our $max_call_tries = @arcfg[10];
our $time_between_call_tries = @arcfg[11];
our $time_zone = @arcfg[13];

  print "\n";

}


sub readcfg_mc {
$id = $_[0];
$query = "select * from masscall_conf where id = '".$id."';";
$sth = $dbh->prepare($query);
$rv = $sth->execute();
if (!defined $rv) {
  print "При выполнении запроса '$query' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}
print "\n$query";
@arcfg = $sth->fetchrow_array();
print "\nResult: @arcfg\n";
our $domain = @arcfg[1];
our $note = @arcfg[2];
our $userfield = @arcfg[3];
our $autocall_id = @arcfg[4];
our $context = @arcfg[5];
our $time_zone = @arcfg[6];

$load_cfg_query = "select * from autocall_conf where context = '".$context."' and id = '".$autocall_id."';";

$query = $load_cfg_query;
print "\n$query";
$sth = $dbh->prepare($query);
$rv = $sth->execute();
if (!defined $rv) {
  print "При выполнении запроса '$query' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}

@arcfg = $sth->fetchrow_array();
print "\nResult: @arcfg\n";
our $callback_ext = @arcfg[1];
our $wait_time = @arcfg[2];
our $deltas_after_hours = @arcfg[3];
our $context = @arcfg[12];
our $note = @arcfg[6];
our $trunk = @arcfg[7];
our $free_agents = @arcfg[8];
our $max_call_tries = @arcfg[10];
our $time_between_call_tries = @arcfg[11];
our $time_zone = @arcfg[13];

};

sub readcfg_mcac {
$autocall_id = $_[0];
$load_cfg_query = "select * from autocall_conf where id = '".$autocall_id."';";

$query = $load_cfg_query;
print "\n$query";
$sth1 = $dbh->prepare($query);
$rv1 = $sth1->execute();
if (!defined $rv1) {
  print "При выполнении запроса '$query' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
};

  @arcfg = $sth1->fetchrow_array();
  print "\nResult: @arcfg\n";
  our $ac_name = @arcfg[0];
  our $callback_ext = @arcfg[1];
  our $wait_time = @arcfg[2];
  our $deltas_after_hours = @arcfg[3];
  our $context = @arcfg[12];
  #our $note = @arcfg[6];
  our $trunk = @arcfg[7];
  our $free_agents = @arcfg[8];
  our $max_call_tries = @arcfg[10];
  our $time_between_call_tries = @arcfg[11];
  our $time_zone = @arcfg[13];
  our $callback_queue = @arcfg[14];

    print "\n";

  };

1;
__END__
