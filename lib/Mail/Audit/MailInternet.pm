package Mail::Audit::MailInternet;

=head1 NAME

Mail::Audit::MailInternet - a Mail::Internet-based Mail::Audit object

=cut

# $Id: /my/icg/mail-audit/trunk/lib/Mail/Audit/MailInternet.pm 22026 2006-06-02T02:13:29.371409Z rjbs  $

use strict;
use Mail::Internet;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
@ISA = qw(Mail::Audit Mail::Internet);

$VERSION = '2.223';

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
