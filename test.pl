# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}
use LSF::Batch;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):
use Config;
$i = 0;
foreach $name( split(" ", $Config{sig_name})){
  $signo{$name} = $i++;
}

$ok2 = 1;
$ok2 = 0 unless $b = new LSF::Batch "myTestApplication";

print "not " unless $ok2;
print "ok 2\n";

exit unless $ok2;

$ok3 = 1;

$ENV{BSUB_QUIET} = 1;

$command = <<EOF;
#!/bin/ksh
for j in 1 2 3 4 5 6 7 8 9 10
do
  for i in 1 2 3 4 5 6 7 8 9 10
  do
    date
    sleep 1
  done
done
EOF

$res = "r1m < 1";
$jname = "testjob1";
$subtime = time;
$cdir = "/tmp";

chdir $cdir;

$job = $b->submit( -command => $command,
                   -resreq => $res,
		   -jobName => $jname
		   );

$ok3 = 0 unless $job;

$id = $job->jobId;
if( $id != -1){
  $job->signal($signo{STOP}) or $ok3 = 0;

  my $rec;
  $rec = $b->openjobinfo($job,undef,undef,undef,undef,0);
  $ok3 = 0 unless $rec;
  while($rec--){
    $j = $b->readjobinfo;
    unless($j){
      $ok3 = 0;
      next;
    }
    next unless $job->jobId == $j->jobId;
    $ok3 = 0 unless IS_SUSP($j->status);
    $ok3 = 0 if abs($j->submitTime - $subtime) > 5;
    $ok3 = 0 unless $j->cwd eq $cdir;
    $ok3 = 0 unless  $j->submit->resReq eq $res;
  }
  $b->closejobinfo;

  $job->signal($signo{CONT}) or $ok3 = 0;
}

print "not " unless $ok3;
print "ok 3\n";

sleep 20;

$ok4 = 1;

$file = $job->peek;

$ok4 = 0 unless $file =~ /$id$/;

open PEEK,"<$file.out";

$first = <PEEK>;
($one) = split /\s+/, $first;

while(<PEEK>){
  ($won) = split;
  $ok4 = 0 unless $one eq $won;
}
close PEEK;

print "not " unless $ok4;
print "ok 4\n";

print "many more tests still need to be written.\n";
@info = $b->userinfo(undef);

$nu = @info;
print "$nu user info records\n";

@info = $b->queueinfo(undef,undef,undef,undef);

$nq = @info;
print "$nq queue info records\n";

@info = $b->sharedresourceinfo(undef,undef);

$ns = @info;
print "$ns shared resource records\n";

@info = $b->hostpartinfo(undef);

$nh = @info;
print "$nh host partition records\n";


exit;
