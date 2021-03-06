# CompareSockperfunderload.pm
package MMTests::CompareSockperfunderload;
use MMTests::Compare;
our @ISA = qw(MMTests::Compare);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "CompareSockperfunderload",
		_DataType    => MMTests::Extract::DATA_TIME_USECONDS,
		_FieldLength => 12,
		_CompareOp   => "pndiff",
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

1;
