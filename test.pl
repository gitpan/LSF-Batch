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
$ok2 = 1;
$ok2 = 0 unless $b = new LSF::Batch "myTestApplication";

print "not " unless $ok2;
print "ok 2\n";
if(0){

@info = $b->userinfo(undef);

$nu = @info;
print "$nu user info records\n";

@info = $b->queueinfo(undef,undef,undef,undef);

$nq = @info;
print "$nq queue info records\n";

@info = $b->sharedresourceinfo(undef,undef);

print scalar(@info)," shared resource records\n";

@info = $b->hostpartinfo(undef);

print scalar(@info), " host partitions\n";
}
$command = <<EOF;
#!/bin/ksh
for i in 1 2 3 4 5 6 7 8 9 10
do
  date
 sleep 10
done
EOF
$name = "minerva.eis.nsa";
$job = $b->submit( -hosts => $name,
		   -jobName => "testjob1.$name.$$",
		    -command => $command,
		   -mailUser => "pmfranc\@nsa"
		 );
$|=1;
exit;
#print "job:",$job,"jobid: ",$job->jobId, "\n";
#print "array index",$job->arrayIdx,"\n";

if( $job->jobId != -1){
  #print "sleeping...\n";
  sleep 10;
  $job->signal(SIGSTOP) or $b->perror("signal SIGSTOP");
  #print "before oji\n";
  #sleep 10;
  #system("bjobs");
  my $rec = 0;
  $rec = $b->openjobinfo($job,undef,undef,undef,undef,0);
  print "got $rec job information records.\n";
  while($rec--){
    $j = $b->readjobinfo;
  }
  print "got to close\n";
  $b->closejobinfo;

  $job->signal(SIGCONT) or $b->perror("signal");
}
$b->perror("here we are");
print "\n";

exit;

$hosts[0] = "revelstone.q.nsa";

$job->run(\@hosts, RUNJOB_OPT_NORMAL) or $b->perror("running job");

# Job calls
#modify
#chkpnt
#mig
#move
#peek
#signal
#switch
#run

#queuecontrol
#sysmsg
#perror

#hostinfo_ex
#hostgrpinfo
#usergrpinfo


exit;

