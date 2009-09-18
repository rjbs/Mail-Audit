package Mail::Audit::Vacation;
use Mail::Audit;
use vars qw(@VERSION $vacfile $message $subject $replyto $from);
$VERSION = '2.224';
$vacfile = ".vacation-cache";
$message = "This user is on vacation.";
$subject = "Vacation autoresponse";
$replyto = $from = "<>";
1;

=head1 NAME

Mail::Audit::Vacation - perform vacation autoresponding

=cut

package Mail::Audit;
use strict;

sub vacation {
  my $item  = shift;
  my $where = shift;
  my $reply = $item->head->get("Reply-To")
    || $item->head->get("From");
  return if $item->head->get("Distribution") =~ /bulk/i or !$reply;
  $item->_log(1, "Vacation thing from $reply");
  if (open TOLD, $Mail::Audit::Vacation::vacfile) {
    while (<TOLD>) {
      if ($_ eq $reply) {
        $item->accept($where);
        return 1;  # Just in case.
      }
    }
  }
  if (open TOLD, ">>" . $Mail::Audit::Vacation::vacfile) {
    print TOLD $item->head->get("Reply-To")
      if $item->head->get("Reply-To");
    print TOLD $item->head->get("From")
      if $item->head->get("From");
    close TOLD;
    use Mail::Mailer qw(sendmail);
    my $out = new Mail::Mailer;
    $out->open(
      {
        From       => $Mail::Audit::Vacation::from,
        Subject    => $Mail::Audit::Vacation::subject,
        To         => $reply,
        "Reply-To" => $Mail::Audit::Vacation::replyto
      }
    );
    print $out $Mail::Audit::Vacation::message;
    $out->close;
  }
  $item->accept($where);

  return 0;
}

