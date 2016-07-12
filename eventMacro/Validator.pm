package eventMacro::Validator;

use strict;

sub new {
	my ( $class, $str ) = @_;
	my $self = bless {}, $class;
	$self->{var}    = [];
	$self->{parsed} = 1;
	$self->parse( $str ) if $str;
	$self;
}

sub parse {
	1;
}

sub parsed {
	$_[0]->{parsed};
}

sub validate {
	1;
}

sub variables {
	my ( $self ) = @_;
	$self->{var};
}

1;