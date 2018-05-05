use v6.c;
use Test;
use P5print;

plan 6;

# Cannot easily check whether print / printf / say were exported, as they
# are additions to the existing multi subs.

my $format;
my $said;

class FakeHandle {
    method print(*@_) { $said = @_.join }
    method printf($template, *@_) { $format = $template, $said = @_.join }
    method say(*@_) { $said = @_.join }
}

{
#    my $*OUT = FakeHandle;
#    my $*ERR = FakeHandle;

    print STDOUT, "foo";
    is $said, "foo", 'was "foo" said with print';

    printf STDOUT, "%s", "bar";
    is $format, '%s', 'did we get the right format';
    is $said, "bar", 'was "bar" said with printf';

    say STDOUT, "baz";
    is $said, "baz", 'was "baz" said with printf';

    print STDERR, "foo";
    is $said, "foo", 'was "foo" said with print to STDERR';

    printf STDERR, "%s", "bar";
    is $format, '%s', 'did we get the right format to STDERR';
    is $said, "bar", 'was "bar" said with printf to STDERR';

    say STDERR, "baz";
    is $said, "baz", 'was "baz" said with printf to STDERR';
}

# vim: ft=perl6 expandtab sw=4
