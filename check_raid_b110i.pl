#!/usr/bin/perl -w
####
#       Author:         Zhivko Todorov <ztodorov@neterra.net>
#       Date:           11-Feb-2015
#       Version:        0.0.1
#       License:        GPL
####

# WARNING:
# check_raid_b110i requires root privileges to run so
# user running the script must be in sudoers file

use strict;
use warnings;
use Getopt::Long;

# Nagios parsable return codes
use constant OK       => 0;
use constant CRITICAL => 2;
use constant UNKNOWN  => 3;

MAIN:
{
        # Values for variable below will be collected from CLI
        my $help          = undef(); # Ask for usage info.


        # Receive command line parameters.
        GetOptions
        (
                "help"           => \$help
        );

        # Show usage info.
        if($help)
        {
                showHelp();
                exit(OK);
        }

        my $dmraidstatus=getDMRAIDstatus();

        if($dmraidstatus eq 'INCONSISTENT')
        {
                print "Status: CRITICAL - RAID Array is INCONSISTENT\n";
                exit(CRITICAL);
        }

        print "Status: OK - RAID Array is OK";
        exit(OK);

} # END MAIN

sub getDMRAIDstatus
{
        my @dmraid_raw = (); # Raw dmraid output

        @dmraid_raw = `/usr/sbin/dmraid -s`;

        chomp(@dmraid_raw);

        return "OK"
                if(grep(/status : ok/, @dmraid_raw));

        return "INCONSISTENT"
                if(grep(/status : inconsistent/, @dmraid_raw));

        print "Status: Unknown\n";
        exit(UNKNOWN);
} # END getNRPEstatus

sub showHelp
{
        my @showHelpMsg =
        (
                "USAGE:",
                "    -h --help  Display help message (this).",
                "",
        );

        print join("\n", @showHelpMsg);
} # END sub showHelp