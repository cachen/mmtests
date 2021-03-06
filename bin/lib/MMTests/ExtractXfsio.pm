# ExtractXfsio.pm
package MMTests::ExtractXfsio;
use MMTests::SummariseMultiops;
use VMR::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub initialise() {
	my ($self, $reportDir, $testName) = @_;
	my $class = shift;
	$self->{_ModuleName} = "ExtractXfsio";
	$self->{_DataType}   = MMTests::Extract::DATA_TIME_SECONDS;
	$self->{_PlotType}   = "client-errorlines";
	$self->{_Opname}     = "ExecTime";
	$self->{_FieldLength} = 12;

	$self->SUPER::initialise($reportDir, $testName);
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($tm, $tput, $latency);
	my $iteration;
	my $testcase;
	my %testcases;

	foreach my $file (<$reportDir/noprofile/*-time.*>) {
		$testcase = $file;
		$testcase =~ s/.*\///;
		$testcase =~ s/-time.*//;

		$testcases{$testcase} = 1;

		open(INPUT, $file) || die("Failed to open $file\n");
		while (<INPUT>) {
			next if $_ !~ /elapsed/;
			push @{$self->{_ResultData}}, [ "$testcase-System", ++$iteration, $self->_time_to_sys($_) ];
			push @{$self->{_ResultData}}, [ "$testcase-Elapsd", ++$iteration, $self->_time_to_elapsed($_) ];
		}
		close(INPUT);
	}

	my @operations;
	foreach $testcase (sort { $a <=> $b } keys %testcases) {
		push @operations, "$testcase-System";
		push @operations, "$testcase-Elapsd";
	}
	$self->{_Operations} = \@operations;
}

1;
