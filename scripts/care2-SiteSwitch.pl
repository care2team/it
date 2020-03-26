#!/usr/bin/env perl


use strict;
use warnings;
#use Data::Dumper;

print <<USAGE;
	To Check the Status:
		sudo $0

	To Enable: Full SJC1 Testing
		sudo $0 enable

	To Enable: ProxyCache Testing
		sudo $0 enable-proxy
		
	To Disable:  ( reverts to the /etc/hosts.presiteswitch file )
		sudo $0 disable

USAGE


#print Dumper (%ENV);
my $arg = "none";
if ( defined ($ARGV[0]) ) {
	$arg = $ARGV[0];
}
# print " == user : $ENV{'USER'} \n";
if ( !($ENV{'USER'} =~ m/root/) ) {
	print "This needs to run as root.  Please try: \n";
	print "  sudo $0 \n";
	exit;
}

my $filename = "/etc/hosts";
my $buffer;

my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($filename);
open FH, "<$filename";
read (FH,$buffer,$size);
close FH;

if ( ! -f "${filename}.presiteswitch" ) 
{
	system("cp ${filename} ${filename}.presiteswitch");
}
my $STR="# #####CareSiteSwitch######";
my $STR2="# SITE=SJC1";

my $STREND="# /#####CareSiteSwitch######";

my %config;
my $inconfig = 0;
foreach my $l ( split (/\n/, $buffer) ) {
	if ( $l =~ m/$STR/ ) {
		$inconfig=1;
	}
	if ( $inconfig  )
	{
		if ( $l =~ m/^# / ) 
		{
			my $x = $l;
			$x=~s/^# //g;
			my @v = split (/=/, $x);
			$config{$v[0]} = $v[1];
		}
	
	}
}
my %ips;
if (  $arg =~ /enable$/i ) {
	$ips{'dingo.care2.com'} = "38.99.122.3";
	$ips{'www.thepetitionsite.com'} = "38.99.122.3";
	$ips{'www.care2.com'} = "38.99.122.3";
	$ips{'earthworm.care2.com'} = "10.32.1.2";
} elsif (  $arg =~ /enable-proxy$/i ) {
	$ips{'dingo.care2.com'} = "38.99.122.6";
	$ips{'www.thepetitionsite.com'} = "38.99.122.6";
	$ips{'www.care2.com'} = "38.99.122.6";

}

$buffer .= $STR . "\n";
$buffer .= $STR2 . "\n";
foreach my $n ( keys %ips ) {
	$buffer .=  $ips{$n} . " $n \n";
}
$buffer .= $STREND . "\n";

#print $buffer;
print "\n";

if ( $inconfig ) { 
	print " == CareSiteSwitch is * ENABLED * \n";
	print " == CareSiteSwitch is pointed to SITE: " .  $config{'SITE'} . "  \n";
	if ( $arg =~ /disable/i ) 
	{
		print " == CareSiteSwitch disabling ... \n";
		if ( -f "${filename}.presiteswitch" ) 
		{
			system("cp -v ${filename}.presiteswitch ${filename}");
			system ("rm -fv ${filename}.presiteswitch");
			system("pkill -f mDNS");
		}
		
		
	}
} else {
	print " == CareSiteSwitch is DISABLED \n";
	if (  $arg =~ /enable/i ) 
	{
		print " == CareSiteSwitch enabling ... \n";
		if ( -f "${filename}.presiteswitch" ) 
		{
			open FH, ">$filename";
			print FH $buffer;
			close FH;		
			system("pkill -f mDNS");
		}		
	}
}



print "\n\n";

