use strict;

use inc::Module::Install;

name          ('Mail-Audit');
author        ('Ricardo SIGNES <rjbs@cpan.org>');

license       ('perl');

version_from  ('lib/Mail/Audit.pm');

requires      ('Fcntl'          => 0);
requires      ('File::Temp'     => 0);
requires      ('File::HomeDir'  => 0.61); # previous v's lack user_home?
requires      ('File::Tempdir'  => 0);
requires      ('MIME::Entity'   => 0);
requires      ('Mail::Internet' => 0);
requires      ('Mail::Mailer'   => 0);
requires      ('Net::SMTP'      => 0);

WriteAll();
