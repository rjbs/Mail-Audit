use strict;
package Mail::Audit::MailInternet;
# ABSTRACT: a Mail::Internet-based Mail::Audit object

use Mail::Internet;
use parent qw(Mail::Audit Mail::Internet);

sub _autotype_new {
  my $class = shift;
  my $self  = shift;
  bless($self, $class);
}

sub new {
  my $class = shift;
  my $type  = ref($class) || $class;

  # we want to create a subclass of Mail::Internet
  # call M::I's constructor
  my $self = Mail::Internet->new(@_);

  # now rebless it into this class
  bless $self, $type;
}

sub is_mime { 0; }

1;
