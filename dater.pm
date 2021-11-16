#!/usr/bin/perl
# get time_period from autocall_conf
package dater;
use AnyEvent::RabbitMQ;
use Data::Dumper;
use JSON;
use DBI;
use DateTime;
use DateTime::Format::ISO8601;
use DateTime::Duration;
#require "readcfg_ac.pm";
#use readcfg;
use threads;
require "/usr/local/sbin/fs/readcfg.pm";
my $dbh = DBI->connect('dbi:Pg:dbname=freeswitchdb;host=127.0.0.1','postgres','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});



if ($DBI::err != 0) {
  print $DBI::errstr . "\n";
  exit($DBI::err);
};



#$ac_id = $ARGV[0] or die "Need an argument - id of autocall_conf;";
sub indate {
  $ac_id = $_[0];
readcfg::readcfg_ac1($ac_id);
$time_period = $readcfg::time_period;
$time_zone = $readcfg::time_zone;
print "\ntime period = $time_period\n";

$DateTimeNow = DateTime->now(time_zone => $time_zone); # берем настоящее время
$dt = DateTime::Format::ISO8601->parse_datetime($DateTimeNow);
$month = $DateTimeNow->month;
$mday = $DateTimeNow->day();
$wday = $DateTimeNow->day_of_week();
$dhour = $DateTimeNow->hour();
$hminute = $DateTimeNow->minute();
$dminute = $dhour*60 + $hminute;
print "\nDateTimeNow = $DateTimeNow mont = $month mday = $mday wday = $wday dhour = $dhour hminute = $hminute dmninute = $dminute\n";




@strings = split (/<condition/, $time_period);
foreach $str (@strings)
{
  unless ($str =~ /version/)
  {
    print "\n--str = $str ----\n";
    if ($str =~ /minute-of-day/)
    {
      #print $&;
      $init_state = 0;
      @period_ar = istimeunit($str, 'minute-of-day');
      print "\nperiod_ar = @period_ar[1]\n";
      if (@period_ar[1])
      {
        $period_ar_mod = isinperiod(@period_ar[1], $dminute, 'minute-of-day');
        print "\nperiod_ar_mod = $period_ar_mod\n";
          if ($period_ar_mod eq "True")
            {
              $init_state++;
              $strwday = $';
              $strother = $`;
              print "\nfirst $str\n";
              if ($str =~ /wday/)
              {
                  if (@period_ar = istimeunit($strwday, 'wday'))
                  {
                    if (isinperiod(@period_ar[1], $wday, 'wday'))
                      {

                        #$init_state++;
                      }
                      else
                      {
                        $init_state = 0;
                      }
                  }
              }
              if ($strother =~ /mday/)
              {
                  if (@period_ar = istimeunit($strother, 'mday'))
                  {
                    if (isinperiod(@period_ar[1], $mday, 'mday') eq "True")
                      {
                        #$str = $`;
                        #$init_state++;
                      }
                      else
                      {
                        $init_state = 0;
                      }
                  }
              }
              if ($str =~ /mon/)
              {
                  if (@period_ar = istimeunit($strother, 'mon'))
                  {
                    if (isinperiod(@period_ar[1], $month, 'mon') eq "True")
                      {
                        #$str = $`;
                        #$init_state++;
                      }
                      else
                      {
                        $init_state = 0;
                      }
                  }
              }

            }
            else
            {
            print "\nperiod_ar_mod = False\n";
            }
      }
        print "\ninit_state = $init_state\n";
    }

  }
        print "\n============ End of unless =============\n";
}

return $init_state;
};

sub isinperiod {
  my $period = $_[0]; my $now_unit = $_[1]; my $descr = $_[2];
  $period =~ /\d+/;
  $part1 = $&;
  $part2 = $';
  $part2 =~ /\d+/;
  $part2 = $&;
  print "\ndescr = $descr period = $period part1 = $part1 part2 = $part2 now_unit = $now_unit\n";
  if (($part1 <= $now_unit) and ($now_unit <= $part2))
    {
      print "\n$descr is IN Period!\n";
      $flag = True;
    }
    else
    {
    $flag = False;
  }
  return $flag;
}

sub istimeunit {
  my $str = $_[0]; my $tu = $_[1];
  if ($str =~ /$tu=/)
  {
    $str = $';
    $str =~ /\\"\d+-\d+\\/;
    $period = $&;
    $left = $`; $right = $';
    print "period = $period\n";
    @splitar = ($left, $period, $right);
  }
  return @splitar;
}

sub time_plus_T {
  $t1 = $_[0];
  $t1 =~ s/\s/T/g;
  $t = DateTime::Format::ISO8601->parse_datetime($t1);
return $t;
}

sub time_minus_T {
  $t1 = $_[0];
  $t1 =~ s/T/ /g;
  return $t1;
}
1;
__END__
