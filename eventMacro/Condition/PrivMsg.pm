package eventMacro::Condition::PrivMsg;

use strict;
use Globals;
use Utils;

use base 'eventMacro::Conditiontypes::RegexConditionEvent';

sub _hooks {
	['packet_privMsg'];
}

sub validate_condition {
	my ( $self, $callback_type, $callback_name, $args ) = @_;
	
	if ($callback_type eq 'hook') {
		$self->{message} = $args->{Msg};
		$self->{source} = $args->{MsgUser};
		$self->SUPER::validate_condition($self->{message});
	} elsif ($callback_type eq 'variable') {
		$self->SUPER::update_validator_var($callback_name, $args);
		return 0;
	}
}

sub get_new_variable_list {
	my ($self) = @_;
	my $new_variables;
	
	my $actor = $monsters{$self->{id}};
	
	$new_variables->{".".$self->{name}."Last"."Name"} = $self->{source};
	$new_variables->{".".$self->{name}."Last"."Msg"} = $self->{message};
	
	return $new_variables;
}

1;