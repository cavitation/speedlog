#! /opt/local/bin/perl

use Getopt::Long;
#use DateTime;

my $logname = '';
GetOptions( 'logname=s' => \$logname );
print "Reading logfile: $logname\n";

my $dt=`date -v-1d "+%Y%m%d"`;
#my $dt=`date "+%Y%m%d"`;
chomp($dt);
print "Using date: $dt\n";

my @ping;
my @dl;
my @ul;

my $sum_ping;
my $sum_dl;
my $sum_ul;

open INPUT, $logname;
my @daters=<INPUT>;


#print "Daters= @daters";

my @results=grep(/$dt/, @daters);
#print "Results= \n@results";

foreach (@results)
{
	my $rst_line=$_;
	chomp($rst_line);

	my @line = split /\|/, $rst_line;

	$sum_ping += $line[1];
	$sum_dl += $line[2];
	$sum_ul += $line[3];

	push(@ping, $line[1]);
	push(@dl, $line[2]);
	push(@ul, $line[3]);
}

my @ping_srt=sort(@ping);
my @dl_srt=sort(@dl);
my @ul_srt=sort(@ul);

my $avg_ping = $sum_ping / $#ping;
my $avg_dl = $sum_dl / $#dl;
my $avg_ul = $sum_ul / $#ul;

#print "Average PING: $avg_ping\n";
#print "Average DL: $avg_dl\n";
#print "Average UL: $avg_ul\n";

printf "\nDATA TYPE  %10s%10s%10s\n", "MIN", "AVG", "MAX";
printf "---------  %10s%10s%10s\n", "---------", "---------", "---------";
printf "PING (ms)  %10.2f%10.2f%10.2f\n", @ping_srt[0], $avg_ping, @ping_srt[-1];
printf "DL (Mb/s)  %10.2f%10.2f%10.2f\n", @dl_srt[0], $avg_dl, @dl_srt[-1];
printf "UL (Mb/s)  %10.2f%10.2f%10.2f\n", @ul_srt[0], $avg_ul, @ul_srt[-1];

print "\n\nFULL DATA LIST:\n";
printf "%-17s%8s%9s%9s\n", "DATE/TIME", "PING", "DL", "UL";
print @results;

print "\n";
print "  >> THAT IS ALL <<\n";

close INPUT;

