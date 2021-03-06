# ExtractSockperfunderload.pm
package MMTests::ExtractSockperfunderload;
use MMTests::SummariseVariabletime;
use VMR::Report;
our @ISA = qw(MMTests::SummariseVariabletime);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractSockperfunderload",
		_DataType    => MMTests::Extract::DATA_TIME_USECONDS,
		_ResultData  => [],
		_Opname      => "Round-Trip-Time",
		_PlotType    => "simple-filter",
	};
	bless $self, $class;
	return $self;
}

sub uniq {
	my %seen;
	grep !$seen{$_}++, @_;
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($protocol);

	my (@sizes, @rates);
	my @files = <$reportDir/noprofile/*-*-1.log>;
	foreach my $file (@files) {
		my @elements = split (/-/, $file);
		$protocol = $elements[-4];
		$protocol =~ s/.*\///;
		push @sizes, $elements[-3];
		push @rates, $elements[-2];
	}
	@sizes = uniq(sort {$a <=> $b} @sizes);
	@rates = uniq(sort {$a <=> $b} @rates);

	my @ops;
	foreach my $size (@sizes) {
		foreach my $rate (@rates) {
			my $file = "$reportDir/noprofile/$protocol-$size-$rate-1.log";
			open(INPUT, $file) || die("Failed to open $file\n");
			my $start_time = 0;

			my $sample = 0;
			while (!eof(INPUT)) {
				my $line = <INPUT>;

				next if $line !~ /^([0-9.]+), ([0-9.]+)/;

				# This is how sockperf calculates rtt internally.
				# Not sure what the /2 is about but without it
				# the report differences from what sockperf
				# spits out in its summary.
				my $rtt = ($2-$1) * 1000000 / 2;
				my $time = $1;

				if (!$start_time) {
					$start_time = $time;
				}

				push @{$self->{_ResultData}}, ["size-$size-rate-$rate", ($time - $start_time), $rtt];
			}
			close(INPUT);
			push @ops, "size-$size-rate-$rate";
		}
	}

	$self->{_Operations} = \@ops;
	close INPUT;
}
1;
