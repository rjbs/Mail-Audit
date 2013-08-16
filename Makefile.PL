use strict;
use ExtUtils::MakeMaker;

use 5.6.0;

WriteMakefile(
  NAME          => 'Mail::Audit',
  VERSION_FROM  => 'lib/Mail/Audit.pm',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Fcntl'          => 0,
    'File::Temp'     => 0,
    'File::HomeDir'  => 0.61, # previous v's lack user_home?
    'File::Tempdir'  => 0,
    'MIME::Entity'   => 0,
    'Mail::Internet' => 0,
    'Mail::Mailer'   => 0,
    'Net::SMTP'      => 0,
  },
  (eval { ExtUtils::MakeMaker->VERSION(6.46) }
    ? (META_MERGE => {
        resources => {
          repository => 'http://github.com/rjbs/mail-audit'
        }
      })
    : ()
  ),
);
