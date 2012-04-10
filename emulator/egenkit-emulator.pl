#!/usr/bin/perl -w
#
# egenkit-emulator.pl
#
# v1.0
#
# Raddle emulator reading input from FILE

$FILE="/home/zabbix/bin/egenkit-dynamic.lst";

use Net::Raddle::SNMPAgent qw(CanonicalOID);
# We need the type definitions when adding individual values
use NetSNMP::ASN (':all');
use NetSNMP::OID (':all');

# net-snmp cannot give us command-line parameters so we use an environment variable
# to set the debug level
#
my $debug = $ENV{RADDLE_DEBUG};
$debug = 0 if not $debug;
print "DEBUG: $debug\n" if $debug;

my $agent = Net::Raddle::SNMPAgent->new() or die "Could not initialise Raddle";

open(FILE) or die("Could not open file.");

foreach $line (<FILE>) {
    chomp($line);
    ($name, $val)=split(/=/, $line); 
    $$Config{$name} = $val;
}
close(FILE);

$val1=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.1.0'};
$val2=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.2.0'};
$val3=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.3.0'};
$val4=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.4.0'};
$val5=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.5.0'};
$val6=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.6.0'};
$val7=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.7.0'};
$val8=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.8.0'};
$val9=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.9.0'};
$val10=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.10.0'};
$val11=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.11.0'};
$val12=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.12.0'};
$val13=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.13.0'};
$val14=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.14.0'};
$val15=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.15.0'};
$val16=$$Config{'.1.3.6.1.4.1.38337.1.1.3.7.4.16.0'};

$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.1.0', ASN_INTEGER, $val1);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.2.0', ASN_INTEGER, $val2);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.3.0', ASN_INTEGER, $val3);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.4.0', ASN_INTEGER, $val4);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.5.0', ASN_INTEGER, $val5);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.6.0', ASN_INTEGER, $val6);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.7.0', ASN_INTEGER, $val7);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.8.0', ASN_INTEGER, $val8);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.9.0', ASN_INTEGER, $val9);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.10.0', ASN_INTEGER, $val10);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.11.0', ASN_INTEGER, $val11);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.12.0', ASN_INTEGER, $val12);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.13.0', ASN_INTEGER, $val13);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.14.0', ASN_INTEGER, $val14);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.15.0', ASN_INTEGER, $val15);
$agent->SetMIBValue('.1.3.6.1.4.1.38337.1.1.3.7.4.16.0', ASN_INTEGER, $val16);
