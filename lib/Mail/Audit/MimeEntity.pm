package Mail::Audit::MimeEntity;

=head1 NAME

Mail::Audit::MailInternet - a Mail::Internet-based Mail::Audit object

=cut

# $Id: /my/icg/mail-audit/trunk/lib/Mail/Audit/MimeEntity.pm 22090 2006-06-05T03:28:52.097940Z rjbs  $

use strict;
use File::Path;
use MIME::Parser;
use MIME::Entity;
use Mail::Audit::MailInternet;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $MIME_PARSER_TMPDIR);
@ISA = qw(Mail::Audit MIME::Entity);

$VERSION = '2.0';

# this may be a security problem on an untrusted multiuser system.
$MIME_PARSER_TMPDIR = "/tmp/" . getpwuid($>) . "-mailaudit";

my $parser;

my @to_rmdir;

sub _autotype_new {
  my $class        = shift;
  my $mailinternet = shift;
  my $options      = shift;

  $parser = MIME::Parser->new();

  $parser->ignore_errors(1);

  if ($options->{output_to_core}) {
    $parser->output_to_core($options->{'output_to_core'});
  } else {
    $mailinternet->_log(3, "doing mkdir $MIME_PARSER_TMPDIR");
    mkdir($MIME_PARSER_TMPDIR, 0777);
    $MIME_PARSER_TMPDIR = "/tmp" unless -d $MIME_PARSER_TMPDIR;
    $parser->output_under($MIME_PARSER_TMPDIR);
  }

  # MIME::Parser has options like extract_nested_messages which are set via
  # option-methods.
  # we'll hand them along here so that if you call Mail::Audit(mimeoptions =>
  # { foo => 1 })
  # the corresponding parser option is set, with $parser->foo(1).
  foreach my $option (keys %$options) {
    next if $option eq "output_to_core";
    if ($parser->can($option)) { $parser->$option($options->{$option}); }
  }

  my $self;

  # todo: add eval error trapping.  if there's a problem, return
  # Mail::Audit::MailInternet as a fallback.
  my $newself = eval {
    $parser->parse_data(
      [ @{ $mailinternet->head->header }, "\n", @{ $mailinternet->body } ]);
  };

  # we won't look at $parser->last_error because we're trying to handle as
  # much as we can.
  my $error = ($@);

  if ($error) {
    return ($newself, "encountered error during parse: $error");

    # note to self:
    # if the error was due to an ill-formed message/rfc822 attachment,
    # we could reparse with extract_nested_messages => 0.
    # it depends how badly the attachment is formed.
    # for now we have ignore_errors(1) and we won't look at
    # $parser->last_error.
  } else {
    $self = $newself;
  }

  unless ($options->{output_to_core}) {
    my $output_dir = $parser->filer->output_dir;
    push @to_rmdir, $output_dir;
    $mailinternet->_log(3, "outputting under $output_dir");
  }

  bless($self, $class);
  return ($self, 0);
}

=head2 parser

This method returns the message's own MIME::Parser.

This method is B<very> likely to go away.

=cut

sub parser { $parser ||= MIME::Parser->new(); }

sub DESTROY {
  my $self = shift;

  $self->_log(3, "running Mail::Audit::MimeEntity DESTROY on $self");

  foreach my $dir (@to_rmdir) {
    next if index($dir, $MIME_PARSER_TMPDIR) != 0;
    $self->_log(3, "attempting to rm $dir");
    rmtree($dir) or $self->_log(3, "rmdir error: $!");
  }

}

sub is_mime { 1; }

1;
