package eventMacro::Validator::ListMemberCheck;

use strict;
use base 'eventMacro::Validator';
use eventMacro::Data;

my $variable_qr = qr/\.?[a-zA-Z][a-zA-Z\d]*/;

sub parse {
	my ( $self, $string_list ) = @_;
	
	$self->{list} = [];
	
	my $has_member_any = 0;
	
	my @list_members = split(/\s*,\s*/, $string_list);
	
	foreach my $member (@list_members) {
		if (!$member) {
			$self->{error} = "A list member is undefined (empty)";
			$self->{parsed} = 0;
			return;
		} elsif ($member =~ /(?:^|(?<=[^\\]))\$($variable_qr)$/) {
			if ($var =~ /^\./) {
				$self->{error} = "System variables should not be used in automacros (The ones starting with a dot '.')";
				$self->{parsed} = 0;
				return;
			}
			push(@{$self->{var}}, $1);
			push(@{$self->{list}}, {member => $1, member_is_var => 1});
		} else {
			push(@{$self->{list}}, {member => $member, member_is_var => 0});
			if ($member =~ /^any$/i) {
				$has_member_any = 1;
			}
		}
	}
	
	if ($has_member_any) {
		# If one list member is 'any' there's no sense in having more members, so return a error
		if (scalar(@list_members) > 1) {
			$self->{error} = "If 'any' is member of the list there should be no other list members";
			$self->{parsed} = 0;
		} else {
			$self->{list_is_any} = 1;
			$self->{parsed} = 1;
		}
	} else {
		$self->{list_is_any} = 0;
		$self->{parsed} = 1;
	}
}

sub validate {
	my ( $self, $possible_member ) = @_;

	return 1 if ($self->{list_is_any});
	
	foreach my $list_member (@{$self->{list}}) {
		my $member = $list_member->{member_is_var} ? $eventMacro->get_var( $list_member->{member} ) : $list_member->{member};
		next unless (defined $member);
		return 1 if ($member eq $possible_member);
	}
	
	return 0;
}

1;
