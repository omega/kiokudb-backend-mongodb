package KiokuDB::Backend::MongoDB::GIN;

use Moose;

use namespace::autoclean;

extends qw(KiokuDB::Backend::MongoDB);

with qw(
    KiokuDB::Backend::Role::Query::GIN
    Search::GIN::Extract::Delegate
);
#has '+inline_data' => ( default => 1 );
has root_only => (
    isa => "Bool",
    is  => "ro",
    default => 0,
);

before 'insert' => sub {
    my ($self, @entries) = @_;
    
    if ($self->extract) {
        foreach my $entry (@entries) {
            if ( $entry->deleted || !$entry->has_object || ( !$entry->root && $self->root_only ) ) {
                $entry->clear_backend_data;
            } else {
                my @keys = $self->extract_values( $entry->object, entry => $entry );

                if ( @keys ) {
                    my $d = $entry->backend_data || $entry->backend_data({});
                    $d->{keys} = \@keys;
                }
            }
        }
    }
};

sub search {
    my ( $self, $query, @args ) = @_;
    return unless ref $self;
    my %spec = $query->extract_values($self);
    use Data::Dump;
    if (!$spec{method} eq 'all') {
        confess("unknown method " . $spec{method} . " in search");
    }
    my $proto = {
        $self->backend_data_field . ".keys" => {
            '$in' => $spec{values} 
        },
    };
    return $self->_proto_search($proto);
}
sub fetch_entry {
    warn "fetch_entry:\n\t" . join ("\n\t", @_);
    
}

sub insert_entry {
    warn "insert_entry:\n\t" . join ("\n\t", @_);
    
}

sub remove_ids {
    warn "remove ids:\n\t" . join ("\n\t", @_);
}


1;