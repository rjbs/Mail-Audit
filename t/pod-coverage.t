#!perl -T

use Test::More;
eval "use Test::Pod::Coverage 1.08";
plan skip_all => "Test::Pod::Coverage 1.08 required for testing POD coverage"
  if $@;

my @modules = all_modules();

plan tests => @modules - 1;

for my $pm (grep { $_ !~ /Razor/ } @modules) {
  pod_coverage_ok($pm, { coverage_class => 'Pod::Coverage::CountParents' });
}
