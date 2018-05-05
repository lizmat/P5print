use v6.c;

# role to distinguish normal Perl 5 handles from normal IO::Handles
my role P5Handle { }

module P5print:ver<0.0.1>:auth<cpan:ELIZABETH> {

    # create standard Perl 5 handles and export them
    my sub term:<<STDIN>>()  is export { $*IN  but P5Handle }
    my sub term:<<STDOUT>>() is export { $*OUT but P5Handle }
    my sub term:<<STDERR>>() is export { $*ERR but P5Handle }

    # add candidates to handle P5Handle
    multi sub print(P5Handle $handle, *@_) {
        $handle.print(@_)
    }
    multi sub printf(P5Handle $handle, Cool:D $format, *@_) {
        $handle.printf($format, @_)
    }
    multi sub say(P5Handle $handle, *@_) {
        $handle.say(@_)
    }
}

=begin pod

=head1 NAME

P5print - Implement Perl 5's print() and associated built-ins

=head1 SYNOPSIS

  use P5print; # exports print, printf, say, STDIN, STDOUT, STDERR

  print STDOUT, "foo";

  printf STDERR, "%s", $bar;

  say STDERR, "foobar";      # same as "note"

=head1 DESCRIPTION

This module tries to mimic the behaviour of the C<print>, C<printf> and
C<say> builtin functions of Perl 5 as closely as possible.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/P5print . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Elizabeth Mattijsen

Re-imagined from Perl 5 as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
