use strict;
use warnings;
package Mail::Audit::Util::Tempdir;
require File::Tempdir;
use parent 'File::Tempdir';
# ABSTRACT: self-cleaning fork-respecting tempdirs

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
