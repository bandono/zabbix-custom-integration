#!/usr/bin/perl -w
#
# v1.0
# return index number against list of items
# the index will be used to address OID

sub indexArray($@)
{
 my $s=shift;
 $_ eq $s && return (@_+1) while $_=pop;
 -1;
}

my @items=(
'Mains phase voltage L1 (V)',
'Mains phase voltage L2 (V)',
'Mains phase voltage L3 (V)',
'Mains phase to phase voltage L1-L2 (V)',
'Mains phase to phase voltage L2-L3 (V)',
'Mains phase to phase voltage L3-L1 (V)',
'Current L1 (A)',
'Current L2 (A)',
'Current L3 (A)',
'Mains total active power (W)',
'Mains total reactive power (Var)',
'Mains total apparent power (VA)',
'Mains total power factor (PF)',
'Mains total active energy (Kwh)',
'Mains total reactive power (Kvarh)',
'Mains frequency (Hz)',
'Temperature (Deg.)',
'Battery  (V)',
'Engine working hours (Hours)'
);

$dat = $ARGV[0];

print indexArray($dat,@items) ."\n";
