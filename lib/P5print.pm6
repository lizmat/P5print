use v6.c;

# role to distinguish normal Perl handles from normal IO::Handles
my role P5Handle { }

module P5print:ver<0.0.4>:auth<cpan:ELIZABETH> {

    # create standard Perl handles and export them
    my sub term:<<STDIN>>()  is export { $*IN  but P5Handle }
    my sub term:<<STDOUT>>() is export { $*OUT but P5Handle }
    my sub term:<<STDERR>>() is export { $*ERR but P5Handle }

    # add candidates to handle P5Handle
    multi sub print(P5Handle $handle, *@_) is export {
        $handle.print(@_)
    }
    multi sub print() is default is export {
        $*OUT.print(CALLERS::<$_>)
    }
    multi sub printf(P5Handle $handle, Cool:D $format, *@_) is export {
        $handle.printf($format, @_)
    }
    multi sub say(P5Handle $handle, *@_) is export {
        $handle.say(@_)
    }
    multi sub say() is default is export {
        $*OUT.say(CALLERS::<$_>)
    }
}

=begin pod

=head1 NAME

P5print - Implement Perl's print() and associated built-ins

=head1 SYNOPSIS

    use P5print; # exports print, printf, say, STDIN, STDOUT, STDERR

    print STDOUT, "foo";

    printf STDERR, "%s", $bar;

    say STDERR, "foobar";      # same as "note"

=head1 DESCRIPTION

This module tries to mimic the behaviour of the C<print>, C<printf> and
C<say> functions of Perl as closely as possible.

=head1 ORIGINAL PERL 5 DOCUMENTATION

    print FILEHANDLE LIST
    print FILEHANDLE
    print LIST
    print   Prints a string or a list of strings. Returns true if successful.
            FILEHANDLE may be a scalar variable containing the name of or a
            reference to the filehandle, thus introducing one level of
            indirection. (NOTE: If FILEHANDLE is a variable and the next token
            is a term, it may be misinterpreted as an operator unless you
            interpose a "+" or put parentheses around the arguments.) If
            FILEHANDLE is omitted, prints to the last selected (see "select")
            output handle. If LIST is omitted, prints $_ to the currently
            selected output handle. To use FILEHANDLE alone to print the
            content of $_ to it, you must use a real filehandle like "FH", not
            an indirect one like $fh. To set the default output handle to
            something other than STDOUT, use the select operation.

            The current value of $, (if any) is printed between each LIST
            item. The current value of $\ (if any) is printed after the entire
            LIST has been printed. Because print takes a LIST, anything in the
            LIST is evaluated in list context, including any subroutines whose
            return lists you pass to "print". Be careful not to follow the
            print keyword with a left parenthesis unless you want the
            corresponding right parenthesis to terminate the arguments to the
            print; put parentheses around all arguments (or interpose a "+",
            but that doesn't look as good).

            If you're storing handles in an array or hash, or in general
            whenever you're using any expression more complex than a bareword
            handle or a plain, unsubscripted scalar variable to retrieve it,
            you will have to use a block returning the filehandle value
            instead, in which case the LIST may not be omitted:

                print { $files[$i] } "stuff\n";
                print { $OK ? STDOUT : STDERR } "stuff\n";

            Printing to a closed pipe or socket will generate a SIGPIPE
            signal. See perlipc for more on signal handling.

    printf FILEHANDLE FORMAT, LIST
    printf FILEHANDLE
    printf FORMAT, LIST
    printf  Equivalent to "print FILEHANDLE sprintf(FORMAT, LIST)", except
            that $\ (the output record separator) is not appended. The FORMAT
            and the LIST are actually parsed as a single list. The first
            argument of the list will be interpreted as the "printf" format.
            This means that "printf(@_)" will use $_[0] as the format. See
            sprintf for an explanation of the format argument. If "use locale"
            (including "use locale ':not_characters'") is in effect and
            POSIX::setlocale() has been called, the character used for the
            decimal separator in formatted floating-point numbers is affected
            by the LC_NUMERIC locale setting. See perllocale and POSIX.

            For historical reasons, if you omit the list, $_ is used as the
            format; to use FILEHANDLE without a list, you must use a real
            filehandle like "FH", not an indirect one like $fh. However, this
            will rarely do what you want; if $_ contains formatting codes,
            they will be replaced with the empty string and a warning will be
            emitted if warnings are enabled. Just use "print" if you want to
            print the contents of $_.

            Don't fall into the trap of using a "printf" when a simple "print"
            would do. The "print" is more efficient and less error prone.

    say FILEHANDLE LIST
    say FILEHANDLE
    say LIST
    say     Just like "print", but implicitly appends a newline. "say LIST" is
            simply an abbreviation for "{ local $\ = "\n"; print LIST }". To
            use FILEHANDLE without a LIST to print the contents of $_ to it,
            you must use a real filehandle like "FH", not an indirect one like
            $fh.

            This keyword is available only when the "say" feature is enabled,
            or when prefixed with "CORE::"; see feature. Alternately, include
            a "use v5.10" or later to the current scope.

=head1 PORTING CAVEATS

In Raku, there B<must> be a comma after the handle, as opposed to Perl
where the whitespace after the handle indicates indirect object syntax.

    print STDERR "whee!";   # Perl way

    print STDERR, "whee!";  # Raku mimicing Perl

Raku warnings on P5-isms kick in when calling C<print> or C<say> without
any parameters or parentheses.  This warning can be circumvented by adding
C<()> to the call, so:

    print;   # will complain
    print(); # won't complain and print $_

=head1 IDIOMATIC PERL 6 WAYS

When needing to write to specific handle, it's probably easier to use the
method form.

    $handle.print("foo");
    $handle.printf("foo");
    $handle.say("foo");

If you want to do a C<say> on C<STDERR>, this is easier done with the C<note>
builtin function:

    $*ERR.say("foo");  # "foo\n" on standard error
    note "foo";        # same

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/P5print . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018-2019 Elizabeth Mattijsen

Re-imagined from Perl as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
