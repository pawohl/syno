#!/usr/bin/env perl

# purpose:
# Certbot manual auth hook script
# Configures tinydns to respond to challenges correctly

use strict;
use warnings;
use File::Copy 'move';
use File::Temp qw/ tempfile tempdir /;

our $domain, our $validation, our $re, our $record;
our $tinydnsdir, our $inputFile, our $outputFile, our $fh, our $lockFile;

$tinydnsdir = '/etc/tinydns/root';
$inputFile = "$tinydnsdir/data";
($fh, $outputFile) = tempfile( DIR => $tinydnsdir, UNLINK => 1, SUFFIX => '.tmp.data' );
$lockFile = '/tmp/tinydns.up.lock';

if ( ! exists $ENV{'CERTBOT_DOMAIN'} || ! defined $ENV{'CERTBOT_DOMAIN'} ) {
    print 'Expected environment variable CERTBOT_DOMAIN.';
    exit 2;
}

if ( ! exists $ENV{'CERTBOT_VALIDATION'} || ! defined $ENV{'CERTBOT_VALIDATION'} ) {
    print 'Expected environment variable CERTBOT_VALIDATION.';
    exit 2;
}

$domain = $ENV{'CERTBOT_DOMAIN'};
$validation = $ENV{'CERTBOT_VALIDATION'};
$re = createMatcher();
$record = createTextRecord();

# Dealing with all this lock stuff isnt fun
# ... maybe using PowerDNS at some point
if ( -e $lockFile ) {
    print 'Another dns update is currently taking place. Abort.';
    exit 1;
}

# always unlock when leaving
END {
    deleteTempFile();
    deleteLockFile();
}

# handle signals because END wont be executed if terminated by signal
use sigtrap 'handler' => \&sigtrap, 'HUP','INT','ABRT','QUIT','TERM';
sub sigtrap(){
    deleteLockFile();
    print 'ACME DNS update script: Cought signal. User abort?';
    exit 1;
}

# Create lock file
open my $lock, '>', $lockFile
    or die "Could not open $lockFile: $!";
print { $lock } "$$\n";
close $lock;

# Update DNS record file
updateRecords();

# Move new file over old one
move $outputFile, $inputFile
    or die "Could not move $inputFile to $outputFile: $!";

# Rebuild tinydns database
`cd $tinydnsdir && make`;

sub updateRecords {
    open my $input, $inputFile
        or die "Could not open $inputFile: $!";
    open my $output, '>' , $outputFile
        or die "Could not open $outputFile: $!";

    # Lock files exclusively for our process
    flock($input, 2) || die "Could not lock $inputFile: $!";
    flock($output, 2) || die "Could not lock $outputFile: $!";

    while( my $line = <$input>) {
        next if ($line =~ /$re/);
        next if ($line =~ /^\s*$/);
        print { $output } $line
            or die "Cannot write to $outputFile: $!";
    }

    print { $output } $record . "\n"
            or die "Cannot write to $outputFile: $!";

    close $input;
    close $output;
}

sub deleteLockFile {
    unlink $lockFile or warn "Could not unlink $lockFile: $!";
}

sub deleteTempFile {
    unlink $outputFile or warn "Could not unlink $outputFile: $!";
}

sub createMatcher {
    my $matcher = "\'_acme-challenge." . escapeText( $domain ) . ":";
    my $regexp = qr/^\Q$matcher\E/;
    return $regexp;
}

sub createTextRecord {
    # 'domain:text:ttl
    return( "\'_acme-challenge." . escapeText( $domain ) . ":" . escapeText( $validation ) . ":" . '5' );
}

sub escapeText {
    my $line = pop @_;
    my $out;
    my @chars = split //, $line;

    foreach my $char ( @chars ) {
	if ( $char =~ /[\r\n\t: \\\/]/ ) {
	    $out = $out . sprintf "\\%.3lo", ord $char;
	}
	else {
	    $out = $out . $char;
	}
    }
    return( $out );
}

