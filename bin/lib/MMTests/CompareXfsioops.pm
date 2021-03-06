# CompareXfsioops.pm
package MMTests::CompareXfsioops;
use MMTests::Compare;
our @ISA = qw(MMTests::Compare);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "CompareXfsioops",
		_DataType    => MMTests::Compare::DATA_OPS_PER_SECOND,
		_CompareOp   => "pdiff",
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

1;
