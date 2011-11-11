use strict;
use warnings;

package Mail::Audit::Util::Tempdir;
require File::Tempdir;
our @ISA = qw(File::Tempdir);

our $VERSION = '2.226';

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  $self->{'Mail::Audit'}{pid} = $$;
  return $self;
}

sub DESTROY {
  return unless do {
    local $@;
    eval { $_[0]->{'Mail::Audit'}{pid} == $$ };
  };
  $_[0]->SUPER::DESTROY;
}

1;

__END__

=head1 NAME

Mail::Audit::Util::Tempdir - self-cleaning fork-respecting tempdirs

=head2 SEE ALSO

L<File::Tempdir>

=cut

