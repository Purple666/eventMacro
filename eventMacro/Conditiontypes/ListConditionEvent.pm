package eventMacro::Conditiontypes::ListConditionEvent;

use strict;

use base 'eventMacro::Condition';

use eventMacro::Data;

sub _parse_syntax {
	my ( $self, $condition_code ) = @_;
	my $validator = $self->{validator} = eventMacro::Validator::ListMemberCheck->new( $condition_code );
	if (defined $validator->error) {
		$self->{error} = $validator->error;
	} else {
		push @{ $self->{variables} }, $validator->variables;
	}
	$validator->parsed;
}

sub validate_condition_status {
	my ( $self, $possible_member ) = @_;
	$self->SUPER::validate_condition_status( $self->{validator}->validate($possible_member) );
}

sub condition_type {
	my ($self) = @_;
	EVENT_TYPE;
}

1;