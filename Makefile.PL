use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'LSF::Batch',
    'VERSION_FROM' => 'Batch.pm', # finds $VERSION
    'LIBS'	=> ['-L/dfs/apps/lsf/lib/ -llsf -lbat -lbsd'],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'OBJECT'	=> '$(O_FILES)',
    'INC'	=> '-I/dfs/apps/lsf/include'   # e.g., '-I/usr/include/other' 
);
