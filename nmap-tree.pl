#!/usr/bin/env perl
#
# Copyright 2022, baybedoll. 
#
# This work is licensed under the terms of the GNU GPL, version 3 or later.
# See the LICENSE file in the top-level directory.

my %tree;

if ($ARGV[0] !~ /.*\.gnmap$/) {
    die "Must supply a .gnmap file! (nmap -oG)\n";
}

open(my $fh, $ARGV[0]) or die "$!\n";

while (<$fh>) {
    if (m/Host: (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) \(.*Ports: (.*)/) {
        my $ip = $1;
        my $ports_str = $2;

        my @ports = split(',', $ports_str);

        foreach my $port (@ports) {
            my @attrs = split('/', $port);

            if ($attrs[1] eq "open") {
	        $attrs[0] =~ s/^\s+|\s+$//g;
		$attrs[5] =~ s/^\s+|\s+$//g;
	    	
		$tree{$ip}{$attrs[2]}{$attrs[0]} = { 'service' => $attrs[4], 'banner' => $attrs[6] };
            }
        }
    }
}

close $fh;

my ($len, $plen, $toffset);

foreach my $ip (keys %tree) {
    if (length $ip > $plen) {
        $len = length $ip;
    }

    $plen = length $ip;
}

for (my $i = 0; $i <= $len + 1; ++$i) {
    $toffset = $toffset . ' ';
}

foreach my $ip (sort keys %tree) {
    my $has_ports = scalar %{$tree{$ip}};
    next if not length $has_ports or ($has_ports <= 0);
    
    my $offset = $len - length $ip;
    my $ioffset;

    for (my $i = 0; $i <= $offset; ++$i) {
        $ioffset = $ioffset . '─';
    }
    
    print "${ip}${ioffset}─┐\n";

    foreach my $proto (sort {$a <=> $b} keys %{$tree{$ip}}) {
        foreach my $port (sort {$a <=> $b} keys %{$tree{$ip}{$proto}}) {
            print "$toffset├── $port/$proto\n";
            print "$toffset│   ├── service : " . $tree{$ip}{$proto}{$port}{'service'} . "\n";
            print "$toffset│   └── banner  : " . $tree{$ip}{$proto}{$port}{'banner'}  . "\n";
        }

	print "\n";
    }
}
